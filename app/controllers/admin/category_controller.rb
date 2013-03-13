class Admin::CategoryController < ApplicationController
  include SessionHelper
  before_filter :require_signed_in
  before_filter :require_admin
  layout 'admin'

  def index
    @categories = Category.where(:level => 1).all
  end

  def sub
    @categories = Category.where("parent_id = ? OR id = ?", params[:id], params[:id]).all
  end


  def new
    @category = Category.new
    @parent_category = Category.find_by_id(params[:parent_id])
  end

  def create
    @category = Category.new (params[:category])
    if @category.save
      redirect_to "/admin/category/sub/#{params[:category][:parent_id]}"
    else 
      render 'new'
    end
  end

  def op
    o = {:ret => 'fail'}
    category  = Category.find_by_id(params[:id])
    unless category.nil? 
      if params[:op] == 'delete'
        category.destroy
        o[:ret] = 'succ'
      end
    end
    render :json => o
  end

end
