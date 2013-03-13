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
