class Editor::DisciplinesController < Editor::BaseController
  record_select :search_on => :name, :order_by => :name
  active_scaffold do |config|
    config.actions = [:list, :nested]
    config.columns = [:short_name, :name]
    config.list.sorting = { :name => :asc }
    config.nested.add_link 'Карты распределения нагрузки', [:charge_cards]
  end
end
