# -*- encoding : utf-8 -*-
module DeptHead::ChargeCardsHelper
  def options_for_association_conditions(association)
    case association.name
    when :teaching_place
      {'teaching_places.department_id' => current_user.department.id}
    when :assistant_teaching_place
      {'teaching_places.department_id' => current_user.department.id}
    when :discipline
      {'disciplines.department_id' => current_user.department.id}
    else
      super
    end
  end

  def charge_card_preferred_classrooms_form_column(record, options)
    grouped_classrooms = Building.all.map { |b| [b.name+" корпус", b.classrooms.map { |c| [c.name_with_recommendation, c.id] }] }
    grouped_classrooms << ["Вне корпусов", Classroom.unscoped.where(building_id: nil).map  { |c| [c.name_with_recommendation, c.id] }]
    select_tag "record[preferred_classrooms][]", grouped_options_for_select(grouped_classrooms, record.preferred_classroom_ids), :multiple => true
  end
end
