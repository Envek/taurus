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

  def beginning_of_chain
    super.where(department_id: current_dept_head.department_id)
  end

end 