# -*- encoding : utf-8 -*-
class Department::TeachingPlacesController < Department::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:position, :lecturer]
    config.list.columns = [:lecturer, :position]
    #config.columns[:lecturer].form_ui = :select
    config.columns[:lecturer].clear_link
    config.columns[:position].form_ui = :select
    config.columns[:lecturer].sort_by :sql => 'lecturers.name'
    config.search.columns = :lecturer
    config.columns[:lecturer].search_sql = 'lecturers.name'
    config.nested.add_link :charge_cards
  end

  include TeachingPlacesConcern

  protected

  def before_create_save(record)
    @dept ||= current_department
    record.department_id = @dept.id
  end

  # Records are filtered according to CanCan abilities.

end
