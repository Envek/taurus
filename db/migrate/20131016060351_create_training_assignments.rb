class CreateTrainingAssignments < ActiveRecord::Migration

  def change
    create_table :training_assignments do |column|
      column.references :lesson_type
      column.integer :weeks_quantity
      column.integer :hours
      column.references :semester
      column.timestamps
    end
    create_table :groups_in_assignments, id: false do |column|
      column.references :group, nullable: false
      column.references :training_assignment, nullable: false
    end
    add_index :groups_in_assignments, [:group_id, :training_assignment_id], uniq: true, name: 'groups_in_assignments_uniq_index'
    create_table :disciplines_in_assignments, id: false do |column|
      column.references :discipline, nullable: false
      column.references :training_assignment, nullable: false
    end
    add_index :disciplines_in_assignments, [:discipline_id, :training_assignment_id], uniq: true, name: 'disciplines_in_assignments_uniq_index'
  end

end
