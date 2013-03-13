class AddNamespaceToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :namespace, :string, :default => 'global'
  end
end
