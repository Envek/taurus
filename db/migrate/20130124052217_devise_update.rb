class DeviseUpdate < ActiveRecord::Migration
  def up
    change_table :users do |table|
      table.datetime :reset_password_sent_at
      table.remove   :remember_token
    end
  end

  def down
    change_table :users do |table|
      table.remove :reset_password_sent_at
      table.string :remember_token
    end
  end
end
