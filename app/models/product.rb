class Product < ActiveRecord::Base
  attr_accessible :shop_click_url, :volume, :json, :click_url, :title, :price, :coupon_price, :coupon_rate, :url, :commission, :commission_num, :commission_rate, :pic_url, :coupon_start_time, :coupon_end_time, :category_id
end
