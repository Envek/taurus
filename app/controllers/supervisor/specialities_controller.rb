# -*- encoding : utf-8 -*-
class Supervisor::SpecialitiesController < Supervisor::BaseController
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
    redirect_to supervisor_training_assignments_path, :notice => "Создано записей: #{created_count}"
  end

end
