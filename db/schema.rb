# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314063153) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "level"
    t.boolean  "is_parent"
    t.string   "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.decimal  "price",             :precision => 8, :scale => 3
    t.decimal  "coupon_price",      :precision => 8, :scale => 3
    t.text     "click_url"
    t.text     "shop_click_url"
    t.text     "pic_url"
    t.datetime "coupon_start_time"
    t.datetime "coupon_end_time"
    t.decimal  "coupon_rate",       :precision => 8, :scale => 3
    t.decimal  "commission_rate",   :precision => 8, :scale => 3
    t.decimal  "commission",        :precision => 8, :scale => 3
    t.integer  "commission_num"
    t.integer  "volume"
    t.string   "num_iid"
    t.string   "nick"
    t.decimal  "commission_volume", :precision => 8, :scale => 3
    t.integer  "category_id"
    t.text     "json"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "sort",                                            :default => 0
    t.boolean  "enabled",                                         :default => true
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "namespace",  :default => "global"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "taobao_categories", :force => true do |t|
    t.integer  "cid"
    t.string   "name"
    t.integer  "level"
    t.integer  "parent_cid"
    t.boolean  "is_parent"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "path"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
    t.boolean  "is_admin",        :default => false
  end

end
