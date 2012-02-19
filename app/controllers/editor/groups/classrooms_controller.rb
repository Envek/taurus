class Editor::Groups::ClassroomsController < ApplicationController
  def index
    classroom_search = params[:classroom].to_s.split
    group = Group.find(params[:group_id])
    dept = group.department
    classroom = Classroom.all_with_recommended_first_for(dept)
    classroom_search.each do |s|
      classroom = classroom.select { |c| c.full_name.include? s }
    end
    respond_to do |format|
      format.json { render :json => classroom.to_json(:only => [:id], :methods => [:name_with_recommendation])}
    end
  end
end
