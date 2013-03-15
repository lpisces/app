class CategoryController < ApplicationController
  def map
    @categories = Category.where(:level => 1).all
  end
end
