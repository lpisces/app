class GoController < ApplicationController
  def product
    product = Product.find_by_id params[:id]
    redirect_to product.click_url unless product.nil?
  end

  def category
  end
end
