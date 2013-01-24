# -*- encoding : utf-8 -*-
class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|

      ## Database authenticatable
      t.string :email,                             :null => false, :default => ""
      t.string :encrypted_password, :limit => 128, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token

      ## Rememberable
      t.string   :remember_token
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Encryptable
      t.string :password_salt

      t.string :type

      t.integer :department_id

      t.string :name
      t.string :login

      t.timestamps
    end
    
    add_index :users, :login,                :unique => true
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
