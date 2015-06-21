class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :log_type
      t.integer :user_id
      t.integer :event_id
      t.integer :reminder_id
      t.text :message
      t.timestamps null: false
    end

    add_index :logs, :log_type
    add_index :logs, :user_id
    add_index :logs, :event_id
    add_index :logs, :reminder_id
  end
end
