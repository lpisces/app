# encoding : utf-8
require 'digest/md5'  
require 'net/http'  
require 'uri'

require 'erb'
require 'active_support'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/string/encoding'
#require 'action_view/helpers/capture_helper'
#require 'action_view/helpers/sanitize_helper'
#include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::SanitizeHelper

namespace :taobao do


  task :cid => :environment do
    parent_cid = Setting.g 'root_cid', 'taobao'
    app_key = Setting.g 'app_key', 'taobao'
    app_secret = Setting.g 'app_secret', 'taobao'
    sub = get_sub_cid(parent_cid, app_key, app_secret)
    next if sub.nil?
    sub['itemcats_get_response']['item_cats']['item_cat'].each do |v|
      save_cid TaobaoCategory, v, 1
      if v['is_parent']
        sub_sub = get_sub_cid(v['cid'], app_key, app_secret)
	next if sub_sub.nil?
	sub_sub['itemcats_get_response']['item_cats']['item_cat'].each do |vv|
          save_cid TaobaoCategory, vv, 2
          if vv['is_parent']
	    sub_sub_sub = get_sub_cid(vv['cid'], app_key, app_secret)
	    next if sub_sub_sub.nil?
	    sub_sub_sub['itemcats_get_response']['item_cats']['item_cat'].each do |vvv|
              save_cid TaobaoCategory, vvv, 3
            end
          end
        end
      end
    end
  end

  task :product => :environment do
    app_key = Setting.g 'app_key', 'taobao'
    app_secret = Setting.g 'app_secret', 'taobao'
    categories = Category.where("level = ? or id = ?", 2, 50008055).all
    categories.each do |c|
      next if TaobaoCategory.where(:cid => c.id).first.nil?
      params = product_params app_key, app_secret, c.id
      json = get(url(params))
      products = ActiveSupport::JSON.decode(json)
      next if products.nil? || products['taobaoke_items_coupon_get_response'].nil? || products['taobaoke_items_coupon_get_response']['taobaoke_items'].nil?
      items = products['taobaoke_items_coupon_get_response']['taobaoke_items']['taobaoke_item']
      next unless items.respond_to? :each
      items.each do |p|
        img_json = get(url(img_params app_key, app_secret, p['num_iid']))
        imgs =  ActiveSupport::JSON.decode(img_json)
        imgs = imgs['items_list_get_response']['items']['item']
        unless imgs[0]['item_imgs'].empty?
          p['imgs'] = []
          imgs[0]['item_imgs']["item_img"].each do |i|
            p['imgs'] << i['url']
          end
        end
        save_product p, c.id, Product
      end
    end
  end

  def save_product(p, category_id, m)
    info = {}
    info['title'] = strip_tags(p['title'])
    info['price'] = p['price'].to_f
    info['coupon_price'] = p['coupon_price'].to_f
    info['coupon_rate'] = p['coupon_rate'].to_f
    info['click_url'] = p['click_url']
    info['shop_click_url'] = p['shop_click_url']
    info['commission'] = p['commission'].to_f
    info['commission_num'] = p['commission_num'].to_f
    info['commission_rate'] = p['commission_rate'].to_f
    info['pic_url'] = p['pic_url']
    info['coupon_start_time'] = p['coupon_start_time']
    info['coupon_end_time'] = p['coupon_end_time']
    info['volume'] = p['volume']
    info['category_id'] = category_id
    info['json'] = ActiveSupport::JSON.encode(p)
    info['imgs'] = p['imgs'].join(',')
    product = m.where(:title => info['title']).first_or_create(info)
    product.update_attributes(info)
  end

  def img_params(app_key, app_secret, num_iid)
    params = {}
    params[:format] = 'json'
    params[:timestamp] = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params[:sign_method] = 'md5'
    params[:v] = '2.0'
    params[:method] = 'taobao.items.list.get'
    params[:fields] = ['item_img.url'].join ','
    params[:num_iids] = num_iid
    params[:app_key] = app_key
    params[:sign] = sign(app_secret, params)
    params
  end

  def product_params(app_key, app_secret, cid)
    params = {}
    params[:format] = 'json'
    params[:timestamp] = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params[:sign_method] = 'md5'
    params[:v] = '2.0'
    params[:method] = 'taobao.taobaoke.items.coupon.get'
    params[:fields] = ['item_imgs', 'num_iid', 'seller_id', 'nick', 'title', 'price', 'item_location', 'seller_credit_score', 'click_url', 'shop_click_url', 'pic_url', 'taobaoke_cat_click_url', 'keyword_click_url', 'coupon_rate', 'coupon_price', 'coupon_start_time', 'coupon_end_time', 'commission_rate', 'commission', 'commission_num', 'commission_volume', 'volume', 'shop_type'].join ','
    params[:cid] = cid
    params[:keyword] = ''
    params[:sort] = 'volume_desc'
    params[:app_key] = app_key
    params[:page_no] = 1
    params[:page_size] = 100
    params[:shop_type] = 'b'
    params[:sign] = sign(app_secret, params)
    params
  end

  def save_cid(m, v, level)
    return nil if v.nil?
    info = {:name => v['name'], :cid => v['cid'], :is_parent => v['is_parent'], :parent_cid => v['parent_cid'], :level => level}
    c = m.where(:cid => v['cid']).first_or_create(info)
    c.update_attributes(info)
  end

  def get_sub_cid(cid, app_key, app_secret)
    format = 'json'
    timestamp = (Time.now).strftime("%Y-%m-%d %H:%M:%S")
    params = {:sign_method => 'md5', :v => '2.0', :app_key => app_key, :format => format, :method => 'taobao.itemcats.get', :fields => 'cid,parent_cid,name,is_parent', :timestamp => timestamp, :parent_cid => cid}
    params[:sign] = sign(app_secret, params)
    json = get(url(params))
    ActiveSupport::JSON.decode(json)
  end

  def sign(app_secret, params) 
    str = []
    str << app_secret
    str << params.sort.join 
    str << app_secret
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
