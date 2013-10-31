class AddMissingIndexes < ActiveRecord::Migration
  def change
  	add_index :buildings, :name
    add_index :classrooms, :building_id
    add_index :classrooms, :department_id
    add_index :classrooms, :name
    add_index :charge_cards_preferred_classrooms, [:classroom_id, :charge_card_id], unique: true, name: 'preferred_classrooms_main_index'
    add_index :subgroups, :jet_id
    add_index :subgroups, :pair_id
    add_index :subgroups, [:jet_id, :pair_id], unique: true
    add_index :groups, :speciality_id
    add_index :groups, :forming_year
    add_index :groups, :name, unique: true
    add_index :pairs, :charge_card_id
    add_index :pairs, :classroom_id
    add_index :pairs, [:day_of_the_week, :pair_number, :week, :active_at, :expired_at], name: 'pair_validation_index'
    add_index :teaching_places, :department_id
    add_index :teaching_places, :lecturer_id
    add_index :teaching_places, :position_id
    add_index :teaching_places, [:department_id, :lecturer_id], unique: true, name: 'teaching_places_main_index'
    add_index :charge_cards, :semester_id
    add_index :charge_cards, :teaching_place_id
    add_index :charge_cards, :assistant_id
    add_index :charge_cards, :lesson_type_id
    add_index :charge_cards, :editor_name
    add_index :training_assignments, :lesson_type_id
    add_index :training_assignments, :semester_id
    add_index :disciplines, :department_id
    add_index :disciplines, :name
    add_index :departments_users, [:department_id, :user_id], unique: true, name: 'department_users_main_index'
    add_index :faculties, :name
    add_index :departments, :faculty_id
    add_index :departments, :dept_head_id
    add_index :departments, :gosinsp_code
    add_index :jets, :charge_card_id
    add_index :jets, :group_id
    add_index :jets, [:charge_card_id, :group_id], name: 'jets_main_index'
    add_index :specialities, :department_id
    add_index :specialities, :code
    add_index :specialities, :name
    add_index :lecturers, :name
  end
end
