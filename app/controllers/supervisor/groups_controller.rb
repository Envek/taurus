class Supervisor::GroupsController < Supervisor::BaseController
  record_select :search_on => :name, :order_by => :name
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:name, :forming_year, :course, :speciality, :population]
    config.create.columns.exclude :course
    config.update.columns.exclude :course
    config.columns[:speciality].form_ui = :select
  end
end
