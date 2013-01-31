class ManyDepartmentsForUser < ActiveRecord::Migration

  def up
    create_table :departments_users, :id => false do |t|
      t.integer :department_id
      t.integer :user_id
    end
    # Move relation from one-to-many to many-to-many
    say_with_time "Moving department ids in the new relation table" do
      User.transaction do
        User.find_in_batches do |users|
          users.each do |user|
            if Department.where(id: user.department_id).any?
              user.department_ids = [user.department_id]
            end
          end
        end
      end
    end
    # Drop old column
    remove_column :users, :department_id
  end

  def down
    add_column :users, :department_id, :integer
    # Move relation back
    say_with_time "Moving department ids back to the users table" do
      User.transaction do
        User.find_in_batches do |users|
          users.each do |user|
            if user.department_ids.any?
              user.department_id = user.department_ids.first
              user.save
            end
          end
        end
      end
    end
    drop_table :departments_users
  end

end
