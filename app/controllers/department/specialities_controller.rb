# -*- encoding : utf-8 -*-
class Department::SpecialitiesController < Department::BaseController
  include SpecialitiesTeachingPlansConcern

  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name]
    config.nested.add_link(:groups)
  end

  protected

  def before_create_save(record)
    record.department_id = current_department.id
  end

end
