# -*- encoding : utf-8 -*-
ActiveScaffold.js_framework = :jquery # :prototype is the default, :jquery as a variant

ActiveScaffold.set_defaults do |config|
  config.actions.exclude :show, :delete
  config.search.live = true
  config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  config.list.per_page = 30
  config.subform.layout = :vertical
end
