class RemoveOauthRelatedFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :oauth_token, :string
    remove_column :users, :oauth_token_expires, :string
    remove_column :users, :oauth_refresh_token, :string
    remove_column :users, :calendar_id, :string

    change_column_default :users, :time_zone, nil
  end
end
