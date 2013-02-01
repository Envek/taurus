# -*- encoding : utf-8 -*-
class Department::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_access_rights, :except => :change_current_department

  def change_current_department
    url = if request.referer.present?
      url_options = Rails.application.routes.recognize_path request.referer
      url_options[:department_id] = current_department.id
      url_for(url_options)
    end
    redirect_to (url.present?? url : department_teaching_places_path(current_department.id))
  end

  protected

  def check_access_rights
    unless Department.accessible_by(current_ability, :update).pluck(:id).include? params[:department_id].to_i
      raise CanCan::AccessDenied
    end
  end

end
