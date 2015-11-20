class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :email
      t.string :password_digest
      t.string :client

      t.timestamps null: false
    end
  end
end
