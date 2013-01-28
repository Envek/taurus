# -*- encoding : utf-8 -*-
class Supervisor::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter { head :forbidden unless current_user.supervisor? }
end
