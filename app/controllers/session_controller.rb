# encoding : utf-8
class SessionController < ApplicationController
  include SessionHelper
  before_filter :auth, :only => [:destroy]

  def new
    redirect_to :root if signed_in?
    @user = User.new
  end

  def create
    user = User.find_by_name(params[:user][:name])
    if user && user.authenticate(params[:user][:password])
      remeber_me = params[:remeber_me].nil?
      sign_in user, remeber_me
      flash[:notice] = '登录成功'
      redirect_to :root
    else
      flash.now[:error] = '登录失败,请检查用户名和密码是否正确'
      @user = User.new
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
