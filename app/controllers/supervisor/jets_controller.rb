class Supervisor::JetsController < ApplicationController
  active_scaffold :jet do |conf|
    conf.columns = [:group, :subgroups_quantity]
    conf.columns[:group].form_ui = :record_select
  end
end 
