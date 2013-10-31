# -*- encoding : utf-8 -*-
class Faculty::SpecialitiesController < Faculty::BaseController

  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name, :department]
    config.nested.add_link :groups
    config.columns[:department].form_ui = :select
    config.actions.add :mark
  end

  include SpecialitiesTeachingPlansConcern

  def generate_training_assignments
    created_count = create_training_assignments
    redirect_to faculty_training_assignments_path(current_faculty), :notice => "Создано записей: #{created_count}"
  end

  def beginning_of_chain
    super.where(department_id: current_faculty.department_ids)
  end

end
