class Editor::Reference::TeachingPlacesController < Editor::BaseController
  active_scaffold :teaching_places do |config|
    config.actions = [:list, :search, :nested]
    config.list.columns = [:position, :lecturer, :whish]
    config.columns[:lecturer].clear_link
    config.columns[:lecturer].sort_by :sql => 'lecturers.name'
    config.columns[:lecturer].search_sql = 'lecturers.name'
    config.search.columns << :lecturer
    config.nested.add_link :charge_cards
  end
end
