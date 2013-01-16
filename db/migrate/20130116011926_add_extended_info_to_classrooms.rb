class AddExtendedInfoToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :title, :string
    add_column :classrooms, :properties, :hstore
  end
end
