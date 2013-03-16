class CategoryController < ApplicationController
  def map
    @categories = Category.where(:level => 1).all
  end

  def show
    @category = Category.find_by_id(params[:id])
    ids = [params[:id],]
    if @category.is_parent
      sub = Category.where(:parent_id => params[:id]).all
      sub.each do |s|
        ids << s.id
      end
    end
    @products = Product.where('coupon_end_time > ?', Date.today).where(:category_id => ids).paginate(:page => params[:page])
  end
end
