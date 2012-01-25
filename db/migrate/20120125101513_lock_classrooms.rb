class LockClassrooms < ActiveRecord::Migration
  def self.up
    change_table :classrooms do |t|
      t.boolean :department_lock, :default => false
    end
  end

  def self.down
    change_table :classrooms do |t|
      t.remove :department_lock
    end
  end
end
