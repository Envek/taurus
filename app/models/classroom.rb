# -*- encoding : utf-8 -*-
class Classroom < ActiveRecord::Base
  has_many :pairs, :dependent => :nullify
  belongs_to :building
  belongs_to :department

  serialize :properties, ActiveRecord::Coders::Hstore

  validates :name, :presence => true, :uniqueness => {:scope => :building_id}

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
    "#{self.name}#{' ('+self.building.name+')' if self.building}#{': '+self.title if self.title}"
  end
  
  def descriptive_name
    dept = "Кафедра #{self.department.short_name}." if self.department
    cap = self.capacity ? "#{self.capacity} человек" : "Вместимость не указана"
    "#{self.full_name}.	#{cap}#{", #{properties_human}" unless properties_human.blank?}. #{dept}"
  end

  def set_recommended_dept(dept)
    @recommended_dept = dept if dept.class == Department
  end

  def name_with_recommendation
    recommended = self.department_id == @recommended_dept.try(:id) && self.department_lock
    "#{descriptive_name} #{"(рекомендуется)" if recommended}"
  end

  def properties_human
    props_string = I18n.t('activerecord.attributes.classroom.property').keys.map do |key|
      if (self.properties or {})[key.to_s]
        I18n.t("activerecord.attributes.classroom.property.#{key}")
      end
    end.compact.join(", ")
    Unicode::downcase(props_string)
  end
end
