# -*- encoding : utf-8 -*-
class DeptHead::DisciplinesController < DeptHead::BaseController
  record_select :search_on => :name, :order_by => :name
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:short_name, :name]
    config.create.columns = [:name, :short_name]
    config.update.columns = [:name, :short_name]
    config.list.sorting = { :name => :asc }
    config.nested.add_link :charge_cards
  end

  protected

  def before_create_save(record)
    if @dept ||= current_user.department
      record.department_id = @dept.id
    end
  end

  def conditions_for_collection
    if @dept ||= current_user.department
      {:department_id => @dept.id}
    else
      {:department_id => nil}
    end
  end
  
  def record_select_conditions_from_controller
    if @dept ||= current_user.department
      {:department_id => @dept.id}
    else
      {:department_id => nil}
    end
  end
end
