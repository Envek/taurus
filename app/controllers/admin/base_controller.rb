class Admin::BaseController < ApplicationController
  before_filter :require_admin

  private

  def require_admin
    current_user && current_user.is_admin?
  end
end