class Supervisor::SpecialitiesController < Supervisor::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name, :department]
    config.nested.add_link('Группы', [:groups])
    config.columns[:department].form_ui = :select
  end

end
