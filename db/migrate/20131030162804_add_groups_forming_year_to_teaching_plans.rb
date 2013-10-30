class AddGroupsFormingYearToTeachingPlans < ActiveRecord::Migration
  def change
    add_column :teaching_plans, :forming_year, :integer, null: false, default: 2013
    add_index  :teaching_plans, [:speciality_id, :discipline_id, :course, :semester, :forming_year], unique: true, name: 'teaching_plans_main_index'
  end
end
