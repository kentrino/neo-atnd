class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.integer :uid

      t.string :name
      t.string :nickname
      t.string :image
      t.text :description

      t.string :access_token
      t.string :access_token_secret

      t.timestamps null: false
    end
  end
end
