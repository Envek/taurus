# -*- encoding : utf-8 -*-
class Editor::Reference::DepartmentsController < Editor::BaseController
  active_scaffold :department do |config|
    config.actions = [:list, :search, :nested]
    config.list.columns = [:name, :short_name, :charge_cards_all, :charge_cards_today]
    config.list.sorting = { :name => :asc }
    config.nested.add_link :disciplines
    config.nested.add_link :teaching_places
  end
end
