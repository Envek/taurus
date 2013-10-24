class CreateFacultyUsers < ActiveRecord::Migration
  def change
    create_table :faculties_users, id: false do |column|
      column.references :faculty, null: false
      column.references :user,    null: false
    end
    add_index :faculties_users, [:faculty_id, :user_id], unique: true, name: 'faculties_users_main_index'
  end
end
