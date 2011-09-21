class Speciality < ActiveRecord::Base
  belongs_to :department
  has_many :groups
  
  validates_presence_of :department
end
