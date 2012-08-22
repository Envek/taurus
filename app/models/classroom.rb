class Classroom < ActiveRecord::Base
  has_many :pairs
  belongs_to :building
  belongs_to :department

  validates_presence_of :building

  default_scope includes(:building).order("classrooms.name ASC, buildings.name ASC")

  def self.all_with_recommended_first_for (department)
    if department.class == Department
      find_by_sql("(
        SELECT classrooms.*
        FROM classrooms JOIN buildings ON classrooms.building_id = buildings.id
        WHERE classrooms.department_id = #{department.id}
        ORDER BY
	        classrooms.department_lock DESC NULLS LAST,
	        classrooms.name ASC,
	        buildings.name ASC
        ) UNION ALL (
        SELECT classrooms.*
        FROM classrooms JOIN buildings ON classrooms.building_id = buildings.id
        WHERE classrooms.department_id <> #{department.id} OR classrooms.department_id IS NULL
        ORDER BY
	        classrooms.name ASC,
	        buildings.name ASC
        )").each do |c|
          c.set_recommended_dept(department)
        end
    else
      all
    end
  end
  
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
