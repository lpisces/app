class Admin::UserController < ApplicationController
  include SessionHelper
  before_filter :require_signed_in
  before_filter :require_admin
  layout 'admin'

  def index
    @users = User.paginate(:page => params[:page]).order('id DESC')
  end

  def op
    o = {:ret => 'fail'}
    user = User.find_by_id(params[:id])
    unless user.nil? 
      if params[:op] == 'set_admin'
        user.update_attribute :is_admin , true
        o[:ret] = 'succ'
      elsif params[:op] == 'unset_admin'
        user.update_attribute :is_admin , false
        o[:ret] = 'succ'
      else
      end
    end
    render :json => o
  end

end
