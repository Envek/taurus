class Editor::Reference::DisciplinesController < Editor::BaseController
  record_select :search_on => :name, :order_by => :name
  active_scaffold :disciplines do |config|
    config.actions = [:list, :search, :nested]
    config.list.columns = [:short_name, :name]
    config.list.sorting = { :name => :asc }
    config.nested.add_link :charge_cards
  end
end
