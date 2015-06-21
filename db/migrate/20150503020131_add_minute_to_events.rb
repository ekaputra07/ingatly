class AddMinuteToEvents < ActiveRecord::Migration
  def change
    add_column :events, :minute, :integer, default: 1

    add_index :events, :minute
  end
end
