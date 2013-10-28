# -*- encoding : utf-8 -*-
class Faculty::TeachingPlacesController < Faculty::BaseController
  active_scaffold :teaching_place do |conf|
    conf.columns = [:department, :lecturer, :position]
    conf.columns[:department].form_ui = :select
    conf.columns[:department].clear_link
    conf.columns[:position].form_ui = :select
    conf.columns[:position].clear_link
    conf.columns[:lecturer].clear_link
    conf.actions << :delete
    conf.nested.add_link :charge_cards
  end

  include TeachingPlacesConcern

end 
