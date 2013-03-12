# encoding : utf-8
module SessionHelper

  def sign_in(user, remeber_me = false)
    if remeber_me
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = { value: user.remember_token, expires: 8.hours.from_now.utc }
    end
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end 

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end 

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def auth
    redirect_to :signin if !signed_in?
  end

  def require_signed_in
    redirect_to :signin if !signed_in?
  end

  def admin?
    !current_user.nil? && current_user.is_admin
  end

  def require_admin
    head :forbidden if !admin?
  end

end
