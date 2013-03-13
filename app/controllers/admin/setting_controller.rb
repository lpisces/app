class Admin::SettingController < ApplicationController
  include SessionHelper
  before_filter :require_signed_in
  before_filter :require_admin
  layout 'admin'


  def index
    @settings = Setting.paginate(:page => params[:page]).order('id DESC')
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new (params[:setting])
    if @setting.save
      redirect_to admin_setting_path
    else 
      render 'new'
    end
  end

  def op
    o = {:ret => 'fail'}
    setting = Setting.find_by_id(params[:id])
    unless setting.nil? 
      if params[:op] == 'delete'
        setting.destroy
        o[:ret] = 'succ'
      end
    end
    render :json => o
  end
end
