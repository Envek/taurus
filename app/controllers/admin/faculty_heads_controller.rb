# -*- encoding : utf-8 -*-
class Admin::FacultyHeadsController < Admin::UsersController
  active_scaffold :user do |config|
    config.columns = [:name, :login, :email, :faculties, :password, :password_confirmation]
    config.list.columns = [:name, :login, :email, :faculties, :current_sign_in_at, :current_sign_in_ip]
    config.columns[:faculties].form_ui = :record_select
  end

  protected

  def beginning_of_chain
    super.includes(:faculties).where("faculties_users.faculty_id IS NOT NULL")
  end

end
