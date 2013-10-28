# -*- encoding : utf-8 -*-
class Admin::FacultiesController < Admin::BaseController
  record_select :search_on => [:name, :full_name], :order_by => :full_name
  active_scaffold do |config|
    config.columns = [:name, :full_name]
  end
end
