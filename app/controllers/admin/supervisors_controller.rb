# -*- encoding : utf-8 -*-
class Admin::SupervisorsController < Admin::UsersController

  protected

  def do_new
    super
    @record.supervisor = true
  end

  def beginning_of_chain
    super.where(supervisor: true)
  end

end
