class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.integer :uid

      t.string :name
      t.string :nickname
      t.string :image
      t.text :description

      t.string :token
      t.string :secret

      t.timestamps null: false

      t.index [:provider, :uid]
    end
  end
end
