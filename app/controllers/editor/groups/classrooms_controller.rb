class Editor::Groups::ClassroomsController < ApplicationController
  def index
    classroom_search = params[:classroom].to_s.split
    group = Group.find(params[:group_id])
    classroom = Classroom.all
    classroom_search.each do |s|
      classroom = classroom.select { |c| c.full_name.include? s }
    end
    classroom.sort! {|a,b| a.full_name <=> b.full_name}
    respond_to do |format|
      format.json { render :json => classroom.to_json(:only => [:id], :methods => [:full_name])}
    end
  end
end
