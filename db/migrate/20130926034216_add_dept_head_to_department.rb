class AddDeptHeadToDepartment < ActiveRecord::Migration
  def change
    change_table :departments do |column|
      column.references :dept_head
    end
  end
end
