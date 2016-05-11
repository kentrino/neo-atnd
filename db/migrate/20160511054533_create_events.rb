class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.integer :capacity
      t.string :location
      t.integer :owner_id
      t.text :description

      t.timestamps null: false

      t.index :owner_id
    end
  end
end
