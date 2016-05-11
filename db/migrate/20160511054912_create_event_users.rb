class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.integer :attendee_user_id
      t.integer :event_id
      t.boolean :absent

      t.timestamps null: false

      t.index :attendee_user_id
      t.index :event_id
    end
  end
end
