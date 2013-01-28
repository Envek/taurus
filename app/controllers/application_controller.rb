# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  clear_helpers
  before_filter :set_current_semester

  helper_method :current_semester
  def current_semester
    @current_semester
  end

  def change_current_semester
    set_current_semester
    redirect_to (request.referer.blank?? timetable_groups_path : request.referer)
  end

protected

  def after_sign_in_path_for(resource)
    return admin_dept_heads_path if current_user.admin?
    return supervisor_lecturers_path if current_user.supervisor?
    return editor_groups_root_path if current_user.editor?
    return dept_head_teaching_places_path if current_user.department
    return request.referrer
  end

  def set_current_semester
    unless params[:semester_id]
      unless session[:current_semester_id]
        year = Date.today.year - (Date.today.month < 8 ? 1 : 0)
        number = Date.today.month < 8 ? 2 : 1
        @current_semester = Semester.published.where(:year => year, :number => number, :full_time => true).first
        @current_semester = Semester.published.first unless @current_semester
        @current_semester = Semester.first unless @current_semester
      else
        @current_semester = Semester.find(session[:current_semester_id])
      end
    else
      @current_semester = Semester.find(params[:semester_id])
    end
    @current_semester = Semester.first unless @current_semester
    Group.current_semester = @current_semester
    session[:current_semester_id] = @current_semester.id
  end

end
