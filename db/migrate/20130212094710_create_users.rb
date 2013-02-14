class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password 
      t.string :password_salt 
      t.string :persistence_token
      t.timestamps
    end
  end

  def down
  	drop_table :users
  end
end
