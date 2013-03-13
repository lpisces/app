# encoding : utf-8
class Setting < ActiveRecord::Base
  attr_accessible :key, :value, :namespace

  self.per_page = 20

  validates :key, :uniqueness => {:message => 'key已经存在'}, :presence => { :message => '请填写key'}, :length => {:to_long => "key不能超过%{count}个字符", :maximum => 256}
end

  public

    def g(key, namespace = 'global')
      v = Setting.where(:key => key, :namespace => namespace).first
      v.nil? ? '' : v.value.to_s
    end
