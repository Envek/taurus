# -*- encoding : utf-8 -*-
class Admin::AdminsController < Admin::UsersController

protected

  def do_new
    super
    @record.admin = true
  end

  def beginning_of_chain
    super.where(admin: true)
  end

end
