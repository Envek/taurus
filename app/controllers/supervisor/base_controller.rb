# -*- encoding : utf-8 -*-
class Supervisor::BaseController < ApplicationController
  before_filter :authenticate_supervisor!
end
