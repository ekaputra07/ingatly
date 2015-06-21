class AddVerifiedFieldsToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :verified, :boolean, default: false
    add_column :reminders, :verification_token, :string

    add_index :reminders, :verified
    add_index :reminders, :verification_token
  end
end
