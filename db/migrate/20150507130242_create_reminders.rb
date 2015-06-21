class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :user_id
      t.integer :reminder_type
      t.string :identifier

      t.timestamps null: false
    end

    add_index :reminders, :user_id
    add_index :reminders, :reminder_type
  end
end
