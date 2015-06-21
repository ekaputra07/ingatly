class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :where
      t.boolean :active, default: true
      t.string :event_type
      t.integer :year
      t.integer :month
      t.integer :date
      t.integer :day
      t.integer :hour

      t.timestamps null: false
    end

    add_index :events, :user_id
    add_index :events, :event_type
    add_index :events, :active
    add_index :events, :hour
  end
end
