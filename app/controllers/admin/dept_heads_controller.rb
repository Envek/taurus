# -*- encoding : utf-8 -*-
class Admin::DeptHeadsController < Admin::UsersController
  active_scaffold :user do |config|
    config.columns = [:name, :login, :email, :departments, :password, :password_confirmation]
    config.list.columns = [:name, :login, :email, :departments, :current_sign_in_at, :current_sign_in_ip]
    config.columns[:departments].form_ui = :record_select
  end

  protected

  def beginning_of_chain
    super.includes(:departments).where("departments_users.department_id IS NOT NULL")
  end

end
