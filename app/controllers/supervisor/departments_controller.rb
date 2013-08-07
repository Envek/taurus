# -*- encoding : utf-8 -*-
class Supervisor::DepartmentsController < Supervisor::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:name, :short_name, :gosinsp_code]
    config.list.columns = [:name, :short_name, :gosinsp_code, :charge_cards_all, :charge_cards_today]
    config.nested.add_link :specialities
    config.nested.add_link :teaching_places
    config.nested.add_link :disciplines
  end
end
