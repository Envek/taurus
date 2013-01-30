# -*- encoding : utf-8 -*-
class DeptHead::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter { raise CanCan::AccessDenied unless current_user.department }
end
