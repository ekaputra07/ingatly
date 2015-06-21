class AddOneAllUserTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oneall_token, :string
    add_column :users, :nopasswd, :boolean, default: false

    add_index :users, :oneall_token
  end
end
