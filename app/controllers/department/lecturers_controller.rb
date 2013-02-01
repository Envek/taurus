# -*- encoding : utf-8 -*-
class Department::LecturersController < Department::BaseController
  record_select :search_on => :name, :order_by => :name
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:name, :whish]
    config.list.sorting = { :name => :asc }
  end
end
