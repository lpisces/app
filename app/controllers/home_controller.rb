class HomeController < ApplicationController

  def index
    @top = Product.order('volume desc').first
  end

end
