class Speciality < ActiveRecord::Base
  belongs_to :department
  has_many :groups
  
  validates_presence_of :department
  
  def to_label
    "#{name} (#{code})"
  end
end
