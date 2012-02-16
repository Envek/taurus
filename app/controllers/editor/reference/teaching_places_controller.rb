class Editor::Reference::TeachingPlacesController < Editor::BaseController
  active_scaffold do |config|
    config.actions = [:list, :nested]
    config.columns = [:position, :lecturer, :whish]
    config.columns[:lecturer].clear_link
    config.columns[:lecturer].sort_by :sql => 'lecturers.name'
    config.list.sorting = { :lecturer => :asc }
    config.nested.add_link('Карты распределения нагрузки', [:charge_cards])
  end
end
