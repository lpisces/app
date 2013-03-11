# encoding : utf-8

class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation


  # validations
  validates :username, :presence => { :message => '请填写用户名'}
  validates :email, :presence => {:message => '请填写Email'}
end
