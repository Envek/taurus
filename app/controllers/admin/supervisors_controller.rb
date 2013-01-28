# -*- encoding : utf-8 -*-
class Admin::SupervisorsController < Admin::BaseController
  active_scaffold :user do |config|
    config.columns = [:name, :login, :email, :password, :password_confirmation]
  end

  protected

  def do_new
    super
    @record.supervisor = true
  end

  def beginning_of_chain
    super.where(supervisor: true)
  end

end
