class AddSortToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sort, :integer, :default => 0
    add_column :products, :enabled, :boolean, :default => true
  end
end
