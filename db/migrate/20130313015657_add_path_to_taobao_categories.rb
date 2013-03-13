class AddPathToTaobaoCategories < ActiveRecord::Migration
  def change
    add_column :taobao_categories, :path, :string
  end
end
