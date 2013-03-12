class Admin::UserController < ApplicationController
  layout 'admin'

  def index
    @users = User.paginate(:page => params[:page]).order('id DESC')
  end

end
