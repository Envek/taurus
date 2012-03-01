class TeachingPlan < ActiveRecord::Base
  belongs_to :speciality
  belongs_to :discipline

  validates_presence_of :speciality_id, :discipline_id, :course, :semester
  validates_numericality_of :course, :semester
  validates_numericality_of :lections, :practics, :lab_works, :allow_nil => true
  validates_inclusion_of :semester, :in => [1, 2]
end
