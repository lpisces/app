#encoding : utf-8
class TaobaoCategory < ActiveRecord::Base
  attr_accessible :name, :cid, :is_parent, :parent_cid, :level, :path

  validates_presence_of :name, :message => '分类名不能为空'
  validates_presence_of :cid, :message => 'cid不能为空'
  validates_presence_of :parent_cid, :message => '上级cid不能为空'
end
