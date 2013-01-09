# -*- encoding : utf-8 -*-
class Admin::BaseController < ApplicationController
  before_filter :authenticate_admin!
end
