# -*- encoding : utf-8 -*-
class Admin::EditorsController < Admin::BaseController
  active_scaffold :user do |config|
    config.columns = [:name, :login, :email, :password, :password_confirmation]
  end

  protected

  def do_new
    super
    @record.editor = true
  end

  def beginning_of_chain
    super.where(editor: true)
  end

end
