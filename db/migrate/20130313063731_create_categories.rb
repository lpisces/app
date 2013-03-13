class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :level
      t.boolean :is_parent
      t.string :path
      t.timestamps
    end
  end
end
