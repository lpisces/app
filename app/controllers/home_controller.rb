class HomeController < ApplicationController

  def index
    @top = Product.order('volume desc').first
    @sub = Product.order('volume desc').offset(1).limit(4)
    @categories = Category.where(:level => 1).all
  end

end
