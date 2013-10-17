class TrainingAssignment < ActiveRecord::Base
  belongs_to :lesson_type
  has_and_belongs_to_many :groups, join_table: :groups_in_assignments
  has_and_belongs_to_many :disciplines, join_table: :disciplines_in_assignments

  validates :weeks_quantity, :hours, numericality: { only_integer: true }

  default_scope includes(:disciplines, :groups)

  def hours_per_week
    hours.to_f/weeks_quantity
  end

end
