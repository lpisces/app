class ChangeTableUsers < ActiveRecord::Migration
  def up
    rename_column :users, :username, :name
    rename_column :users, :password_hash, :password_digest
  end

  def down
    rename_column :users, :name, :username
    rename_column :users, :password_digest, :password_hash
  end
end
