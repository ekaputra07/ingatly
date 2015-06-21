class CreateEventReminders < ActiveRecord::Migration
  def change
    create_table :events_reminders, id: false do |t|
      t.integer :event_id
      t.integer :reminder_id
    end

    add_index :events_reminders, :event_id
    add_index :events_reminders, :reminder_id
  end
end
