#encoding : utf-8
class Category < ActiveRecord::Base
  attr_accessible :is_parent, :level, :name, :parent_id

  validates :name, :uniqueness => {:message => '分类名已经存在'}, :presence => { :message => '请填写分类名'}, :length => {:to_long => "分类名不能超过%{count}个字符", :maximum => 64,  :minimum   => 1, :too_short => "分类名太短了喔"}

  validates :is_parent, :inclusion => { :in => [true, false], :message => '此项值只能为0或1'}, :presence => {:message => '请填写是否父类'}
  validates :level, :inclusion => { :in => [1, 2, 3], :message => '此项值只能为1 2 3'}, :presence => {:message => '请填写分类级别'}

end
