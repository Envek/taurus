class TrainingAssignment < ActiveRecord::Base
  belongs_to :lesson_type, inverse_of: :training_assignments
  belongs_to :semester, inverse_of: :training_assignments
  has_and_belongs_to_many :groups, join_table: :groups_in_assignments
  has_and_belongs_to_many :disciplines, join_table: :disciplines_in_assignments

  validates :weeks_quantity, :hours, presence: true, numericality: { only_integer: true }
  validates :lesson_type, :semester, presence: true

  default_scope includes(:disciplines, :groups)

  def hours_per_week
    (hours.nil? or weeks_quantity.nil?) ? 0 : hours.to_f/weeks_quantity
  end

end
