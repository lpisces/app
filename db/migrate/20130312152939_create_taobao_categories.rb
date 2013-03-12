class CreateTaobaoCategories < ActiveRecord::Migration
  def change
    create_table :taobao_categories do |t|
      t.integer :cid
      t.string :name
      t.integer :level
      t.integer :parent_cid
      t.boolean :is_parent
      t.timestamps
    end
  end
end
