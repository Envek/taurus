class RemoveStiFromUsers < ActiveRecord::Migration

  def up
    add_column :users, :admin, :boolean, default: false
    add_column :users, :supervisor, :boolean, default: false
    add_column :users, :editor, :boolean, default: false
    execute "UPDATE users SET admin = True WHERE type = 'Admin';"
    execute "UPDATE users SET supervisor = True WHERE type = 'Supervisor';"
    execute "UPDATE users SET editor = True WHERE type = 'Editor';"
    remove_column :users, :type
  end

  def down
    add_column :users, :type, :string
    execute <<-SQL
      UPDATE users SET type = (CASE
        WHEN admin = True THEN 'Admin'
        WHEN supervisor = True THEN 'Supervisor'
        WHEN editor = True THEN 'Editor'
        ELSE 'DeptHead'
      END);
    SQL
    remove_column :users, :admin
    remove_column :users, :supervisor
    remove_column :users, :editor
  end

end
