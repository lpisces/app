class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.column :price, :'decimal(8,3)'
      t.column :coupon_price, :'decimal(8,3)'
      t.text   :click_url
      t.text   :shop_click_url
      t.text   :pic_url
      t.datetime :coupon_start_time
      t.datetime :coupon_end_time
      t.column :coupon_rate, :'decimal(8,3)'
      t.column :commission_rate, :'decimal(8,3)'
      t.column :commission, :'decimal(8,3)'
      t.column :commission_num, :integer
      t.integer :volume
      t.string :num_iid
      t.string :nick
      t.column :commission_volume, :'decimal(8,3)'
      t.integer :category_id
      t.text :json
      t.timestamps
    end
  end
end
