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

  def set_current_semester
    unless params[:semester_id]
      unless session[:current_semester_id]
        year = Date.today.year - (Date.today.month < 6 ? 0 : 1)
        number = Date.today.month < 6 ? 1 : 2
        semester = Semester.find_by_year_and_number_and_full_time(year, number, true)
        semester = Semester.first unless semester
        session[:current_semester_id] = semester.id
      end
    else
      session[:current_semester_id] = params[:semester_id]
    end
    @current_semester = Semester.find(session[:current_semester_id])
    @current_semester = Semester.first unless @current_semester
    redirect_to request.referer if params[:semester_id]
  end

end
