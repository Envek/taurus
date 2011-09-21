class Supervisor::SpecialitiesController < Supervisor::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name]
    config.nested.add_link('Группы', [:groups])
  end

end
