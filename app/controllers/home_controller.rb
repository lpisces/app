class HomeController < ApplicationController

  def index
    @top = Product.where('coupon_end_time > ?', Date.today).order('volume desc').first
    @sub = Product.where('coupon_end_time > ?', Date.today).order('volume desc').offset(1).limit(4)
    @categories = Category.where(:level => 1).all
  end

end
