# encoding : utf-8
require 'digest/md5'  
require 'net/http'  
require 'uri'

require 'erb'
require 'active_support'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/string/encoding'
require 'action_view/helpers/capture_helper'
require 'action_view/helpers/sanitize_helper'
include ActionView::Helpers::SanitizeHelper

namespace :taobao do
  desc '通过淘宝api获取淘宝客数据'
  task :update_cid => :environment do
    api_url = 'http://gw.api.taobao.com/router/rest'
    app_key = AppConfig.where('`key` = "taobao_app_key"').first
    secret_key = AppConfig.where('`key` = "taobao_secret_key"').first
    format = 'json'
    timestamp = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params = {:sign_method => 'md5', :v => '2.0', :app_key => app_key.value, :format => format, :method => 'taobao.itemcats.get', :fields => 'cid,parent_cid,name,is_parent', :timestamp => timestamp, :parent_cid => 0}
    str = ''
    str << secret_key.value << params.sort.join << secret_key.value
    p str
    sign = Digest::MD5.hexdigest(str).upcase
    url = []
    params.sort.each {|k, v| url << (k.to_s << '=' << URI.encode(v.to_s).to_s)}
    p api_url << '?' << (url.join '&') << '&' << 'sign=' << sign
  end

  task :cid => :environment do
    taobao_keys = AppConfig.get_taobao_keys
    format = 'json'
    timestamp = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params = {:sign_method => 'md5', :v => '2.0', :app_key => taobao_keys[:app_key], :format => format, :method => 'taobao.itemcats.get', :fields => 'cid,parent_cid,name,is_parent', :timestamp => timestamp, :parent_cid => 0}
    params[:sign] = sign(taobao_keys, params)
    json = get(url(params))
    cate = ActiveSupport::JSON.decode(json)
    cate['itemcats_get_response']['item_cats']['item_cat'].each do |v|
      TaobaoCategory.where(:cid => v['cid']).first_or_create(:name => v['name'], :cid => v['cid'])
    end
  end

  task :product => :environment do
    cnt = TaobaoConfig.count
    next if cnt < 1 
    conf = TaobaoConfig.order('version asc').first
    conf_last = TaobaoConfig.order('version asc').last
    if (conf_last.global_version != conf.global_version) 
      conf.global_version = conf_last.global_version
      conf.version = conf_last.version - 1
      conf.save
    end
    if conf.version == conf.global_version
      TaobaoConfig.update_all :global_version => (conf.global_version + 1).to_s
      next
    end
    conf.version += 1
    conf.save
    taobao_keys = AppConfig.get_taobao_keys
    params = {}
    params[:format] = 'json'
    params[:timestamp] = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params[:sign_method] = 'md5'
    params[:v] = '2.0'
    params[:method] = 'taobao.taobaoke.items.coupon.get'
    params[:fields] = ['num_iid', 'seller_id', 'nick', 'title', 'price', 'item_location', 'seller_credit_score', 'click_url', 'shop_click_url', 'pic_url', 'taobaoke_cat_click_url', 'keyword_click_url', 'coupon_rate', 'coupon_price', 'coupon_start_time', 'coupon_end_time', 'commission_rate', 'commission', 'commission_num', 'commission_volume', 'volume', 'shop_type'].join ','
    params[:cid] = conf.taobao_category.cid
    params[:keyword] = conf.keyword
    params[:sort] = 'volume_desc'
    params[:page_size] = conf.amount
    params[:page_no] = 1
    params[:app_key] = taobao_keys[:app_key]
    params[:sign] = sign(taobao_keys, params)

    json = get(url(params))
    products = ActiveSupport::JSON.decode(json)
    mall = Mall.where('name = "淘宝"').first
    products['taobaoke_items_coupon_get_response']['taobaoke_items']['taobaoke_item'].each do |p|
      info = {}
      info['name'] = strip_tags(p['title'])
      info['price'] = p['price'].to_f
      info['coupon_price'] = p['coupon_price'].to_f
      info['coupon_rate'] = p['coupon_rate'].to_f
      info['url'] = p['click_url']
      info['commission'] = p['commission'].to_f
      info['commission_num'] = p['commission_num'].to_f
      info['commission_rate'] = p['commission_rate'].to_f
      info['image'] = p['pic_url']
      info['coupon_start_time'] = p['coupon_start_time']
      info['coupon_end_time'] = p['coupon_end_time']
      info['mall_id'] = mall.id
      info['category_id'] = conf.category_id
      product = Product.where(:name => info['name']).first_or_create(info)
      product.update_attributes(info)
      conf.tags.each do |t|
        product.tags << t if !product.tags.exists?(t) 
      end
    end
  end

  def sign(taobao_keys, params) 
    str = []
    str <<  taobao_keys[:secret_key] 
    str << params.sort.join 
    str << taobao_keys[:secret_key]
    Digest::MD5.hexdigest(str.join).upcase
  end

  def api_url
    api_url = 'http://gw.api.taobao.com/router/rest'
  end

  def url(params)
    url = []
    params.sort.each {|k, v| url << (k.to_s << '=' << URI.encode(v.to_s).to_s)}
    api_url << '?' << (url.join '&')
  end

  def get(url)
    res = Net::HTTP.get_response(URI.parse(url))
    res.body 
  end
end
