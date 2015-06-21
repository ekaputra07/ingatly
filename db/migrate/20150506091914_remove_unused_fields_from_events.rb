class RemoveUnusedFieldsFromEvents < ActiveRecord::Migration
  def change
    # Add weekday column
    add_column :events, :wday, :integer

    # Remove the old columns
    remove_column :events, :year, :string
    remove_column :events, :month, :string
    remove_column :events, :date, :string
    remove_column :events, :day, :string
    remove_column :events, :hour, :string
    remove_column :events, :minute, :string
  end
end
