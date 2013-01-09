# -*- encoding : utf-8 -*-
class Supervisor::DisciplinesController < ApplicationController
  record_select :search_on => :name, :order_by => :name
  active_scaffold :discipline do |conf|
    conf.actions << :delete
    conf.columns = [:short_name, :name]
    conf.create.columns = [:name, :short_name]
    conf.update.columns = [:name, :short_name]
    conf.list.sorting = { :name => :asc }
    conf.nested.add_link :charge_cards
  end
end 
