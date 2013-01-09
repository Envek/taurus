# -*- encoding : utf-8 -*-
class Editor::Classrooms::ClassroomsController < Editor::BaseController

  def index
    flash[:error] = nil
    session[:classroom_editor] = {:classrooms => []} unless session[:classroom_editor]
    except = session[:classroom_editor][:classrooms].any? ? session[:classroom_editor][:classrooms] : "0"
    classroom = params[:classroom].to_s.gsub('%', '\%').gsub('_', '\_') + '%'
    @classrooms = Classroom.where(['classrooms.id NOT IN (?) AND classrooms.name ILIKE ?', except, classroom]).includes(:building)
    respond_to do |format|
      format.html
      format.json { render :json => @classrooms.to_json(:only => [:id, :name], :include => { :building => { :only => :name } } )}
    end
  end

  def show
    @days = Timetable.days
    @times = Timetable.times
    @weeks = Timetable.weeks
    @classroom = Classroom.includes(:pairs).find(params[:id])
    unless @classroom
      flash[:error] = 'Нет аудитории с таким названием'
    else
      @pairs = @classroom.pairs.in_semester(current_semester).order("active_at ASC")
      session[:classroom_editor] = {:classrooms => []} unless session[:classroom_editor]
      session[:classroom_editor][:classrooms] << @classroom.id unless session[:classroom_editor][:classrooms].include? @classroom.id
      respond_to do |format|
        format.js
      end
    end
  end

  def edit

  end

  def update

  end

  def destroy
    if session[:classroom_editor].include? :classrooms
      @id = params[:id].to_i
      session[:classroom_editor][:classrooms].delete(@id)
      respond_to do |format|
        format.js
      end
    end
  end
end
