class Supervisor::FacultiesController < Supervisor::BaseController
   active_scaffold do |config|
    config.actions << :delete
    config.columns = [:full_name, :name]
    config.nested.add_link :departments
  end
end
