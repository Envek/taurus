# -*- encoding : utf-8 -*-
class Faculty::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_access_rights, :except => :change_current_faculty

  def change_current_faculty
    url = if request.referer.present?
      url_options = Rails.application.routes.recognize_path request.referer
      url_options[:faculty_id] = current_faculty.id
      url_for(url_options)
    end
    redirect_to (url.present?? url : faculty_training_assignments_path(current_faculty.id))
  end

  protected

  def check_access_rights
    unless Faculty.accessible_by(current_ability, :update).pluck(:id).include? params[:faculty_id].to_i
      raise CanCan::AccessDenied
    end
  end

end
