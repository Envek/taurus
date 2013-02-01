# -*- encoding : utf-8 -*-
class Supervisor::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter { raise CanCan::AccessDenied unless [:supervisor, :admin].any? {|r| current_user.send(r)} }
end
