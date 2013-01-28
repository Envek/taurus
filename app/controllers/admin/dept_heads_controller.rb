# -*- encoding : utf-8 -*-
class Admin::DeptHeadsController < Admin::BaseController
  active_scaffold :user do |config|
    config.columns = [:department, :name, :login, :email, :password, :password_confirmation]
    config.columns[:department].form_ui = :record_select
    config.columns[:department].clear_link
  end

  protected

  def beginning_of_chain
    super.where("department_id IS NOT NULL")
  end

end
