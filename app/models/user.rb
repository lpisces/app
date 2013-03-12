# encoding : utf-8

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :captcha, :captcha_key
  attr_reader :password

  apply_simple_captcha :message => "验证码不正确"

  before_save {|user| user.email = email.downcase}
  before_save :create_remember_token

  # validations
  validates :name, :uniqueness => {:message => '用户名已经存在'}, :presence => { :message => '请填写用户名'}, :length => {:to_long => "用户名不能超过%{count}个字符", :maximum => 64,  :minimum   => 4, :too_short => "用户名太短了喔"}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => {:message => '请填写Email'}, :format => {:with => VALID_EMAIL_REGEX, :message => 'Email格式不对'}

  validates_presence_of :password_digest, :message => '密码不能为空'
  validates_presence_of :password_confirmation, :message => '请确认密码'
  validates_confirmation_of :password, :message => '密码不匹配'

  if respond_to?(:attributes_protected_by_default)
    def self.attributes_protected_by_default
      super + ['password_digest']
    end
  end

  def password=(unencrypted_password)
    require 'bcrypt'
    unless unencrypted_password.blank?
      @password = unencrypted_password
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def password_confirmation=(unencrypted_password)
    unless unencrypted_password.blank?
      @password_confirmation = unencrypted_password
    end
  end

  def authenticate(unencrypted_password)
    require 'bcrypt'
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

   private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
