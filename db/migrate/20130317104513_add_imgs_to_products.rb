class AddImgsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :imgs, :text
  end
end
