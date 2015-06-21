class AddReminderDateTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reminder_time, :datetime
    add_index :events, :reminder_time
  end
end
