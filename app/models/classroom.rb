class Classroom < ActiveRecord::Base
  has_many :pairs
  belongs_to :building
  belongs_to :department

  validates_presence_of :building
  
  named_scope :recommended_first_for, lambda { |dept| {
    :joins => [:building, :department],
    :order => "classrooms.department_id=#{dept.id} DESC NULLS LAST,
                 classrooms.department_lock DESC NULLS LAST,
                 classrooms.name ASC,	buildings.name ASC"
  }}
  
  def full_name
    name + ' (' + building.name + ')'
  end
  
  def descriptive_name
    dept = "Кафедра #{self.department.short_name}." if self.department
    cap = self.capacity ? "#{self.capacity} человек" : "не указана"
    "#{self.name} (#{self.building.name}).	Вместимость: #{cap}. #{dept}"
  end

  def set_recommended_dept(dept)
    @recommended_dept = dept if dept.class == Department
  end

  def name_with_recommendation
    recommended = self.department_id == @recommended_dept.try(:id) && self.department_lock
    "#{descriptive_name} #{"(рекомендуется)" if recommended}"
  end
end
