class DeptHead::ClassroomsController < ApplicationController
  active_scaffold :classroom do |conf|
    conf.actions.exclude :create
    conf.columns = [:building, :name, :title, :department, :department_lock, :capacity, :properties]
    conf.update.columns = [:title, :capacity, :properties]
    conf.columns[:building].clear_link
    conf.columns[:department].clear_link
  end

  def before_update_save(record)
    record[:properties] = params[:record][:properties]
  end

  # Records are filtered according to CanCan abilities.

end 
