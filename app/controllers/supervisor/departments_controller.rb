class Supervisor::DepartmentsController < Supervisor::BaseController
  active_scaffold do |config|
    config.columns = [:name, :short_name]
    config.nested.add_link('Специальности', [:specialities])
  end
end
