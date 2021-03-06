class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.integer :capacity
      t.string :location
      t.integer :owner_id
      t.string :owner
      t.text :description

      t.timestamp :hold_at

      t.timestamps null: false

      t.index :owner_id
      t.index :hold_at
    end
  end
end
