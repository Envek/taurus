# -*- encoding : utf-8 -*-
class Editor::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter { raise CanCan::AccessDenied unless [:editor, :supervisor, :admin].any? {|r| current_user.send(r)} }
end
