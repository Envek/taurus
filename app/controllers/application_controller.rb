# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  clear_helpers
  before_filter :set_current_semester

  rescue_from CanCan::AccessDenied do |exception|
    raise exception if Rails.env.development?
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end

  helper_method :current_semester
  def current_semester
    @current_semester
  end

  def change_current_semester
    set_current_semester
    redirect_to (request.referer.blank?? timetable_groups_path : request.referer)
  end

  helper_method :current_department
  def current_department
    @current_department ||= (params[:department_id].present? and Department.find(params[:department_id]))
    @current_department ||= Department.accessible_by(current_ability, :update).where(id: session[:current_department_id]).first
    @current_department ||= Department.accessible_by(current_ability, :update).first
    session[:current_department_id] = @current_department.id
    return @current_department
  end

  helper_method :current_faculty
  def current_faculty
    @current_faculty ||= (params[:faculty_id].present? and Faculty.find(params[:faculty_id]))
    @current_faculty ||= Faculty.accessible_by(current_ability, :update).where(id: session[:current_faculty_id]).first
    @current_faculty ||= Faculty.accessible_by(current_ability, :update).first
    session[:current_faculty_id] = @current_faculty.id
    return @current_faculty
  end

protected

  def after_sign_in_path_for(resource)
    return admin_dept_heads_path if current_user.admin?
    return supervisor_lecturers_path if current_user.supervisor?
    return editor_groups_root_path if current_user.editor?
    return faculty_training_assignments_path(current_user.faculty_ids.first) if current_user.faculty_ids.any?
    return department_teaching_places_path(current_user.department_ids.first) if current_user.department_ids.any?
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

  helper_method :current_ability
  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

end
