class Supervisor::SemestersController < ApplicationController
  active_scaffold :semester do |conf|
    conf.actions << :delete
    conf.list.columns = [:academic_year, :number, :full_time, :charge_card_count]
    conf.create.columns = [:year, :number, :full_time]
    conf.update.columns = [:year, :number, :full_time]
    conf.columns[:full_time].form_ui = :checkbox
  end
end 
