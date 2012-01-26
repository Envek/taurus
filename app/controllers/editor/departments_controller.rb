class Editor::DepartmentsController < Editor::BaseController
  active_scaffold do |config|
    config.actions = [:list, :nested]
    config.columns = [:name, :short_name]
    config.list.sorting = { :name => :asc }
    config.nested.add_link('Дисциплины', [:disciplines])
    config.nested.add_link('Преподаватели', [:teaching_places])
  end
end
