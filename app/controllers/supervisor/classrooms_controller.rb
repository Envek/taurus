class Supervisor::ClassroomsController < Supervisor::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:building, :name, :department, :capacity]
    config.columns[:building].form_ui = :select
    config.columns[:department].form_ui = :select
    config.columns[:building].clear_link
    config.columns[:department].clear_link
  end
end
