# encoding : utf-8
class Admin::ProductController < ApplicationController
  include SessionHelper
  before_filter :require_signed_in
  before_filter :require_admin
  layout 'admin'

  def index
    @top_categories = Category.where(:level => 1).all
    @search = Product.search(params[:q])
    @products = @search.result.paginate(:per_page => 20, :page => params[:page])
  end
end
