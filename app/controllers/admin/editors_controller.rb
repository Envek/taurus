# -*- encoding : utf-8 -*-
class Admin::EditorsController < Admin::UsersController

  protected

  def do_new
    super
    @record.editor = true
  end

  def beginning_of_chain
    super.where(editor: true)
  end

end
