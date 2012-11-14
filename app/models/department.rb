class Department < ActiveRecord::Base
  belongs_to :faculty
  has_many :classrooms, :dependent => :nullify
  has_many :disciplines, :dependent => :destroy
  has_many :teaching_places, :dependent => :destroy
  has_many :lecturers, :through => :teaching_places
  has_many :specialities, :dependent => :destroy
  has_many :dept_heads, :dependent => :destroy
  
  validates_numericality_of :gosinsp_code, :allow_nil => true

end
