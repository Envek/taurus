class Timetable::ClassroomsController < Timetable::BaseController

  def index
    @buildings = Building.includes(:classrooms).reorder("buildings.id,(substring(classrooms.name, '^[0-9]+'))::int,substring(classrooms.name, '[^0-9_].*$')")
    @buildings = @buildings.where("classrooms.name ILIKE ? OR classrooms.title ILIKE ? OR buildings.name ILIKE ?", *(["%#{params[:classroom]}%"]*3)) if params[:classroom]
    respond_to do |format|
      format.html do
        if @buildings.count == 1 and @buildings.first.classrooms.count == 1
          redirect_to timetable_classroom_path(@buildings.first.classrooms.first)
        end
      end
      format.json do
        render :json => @buildings.to_json(only: [:id, :name], include: {classrooms: {only: [:id, :title, :name]}})
      end
    end
  end

  def show
    @id = params[:id].to_i
    unless @classroom = Classroom.find_by_id(@id)
      suffix = @terminal ? '?terminal=true' : ''
      redirect_to :controller => 'timetable/classrooms' + suffix
    else
      pairs = @classroom.pairs.includes(:subgroups).in_semester(current_semester).flatten
      @days = Timetable.days
      @times = Timetable.times
      @weeks = Timetable.weeks
      @pairs = Array.new(@days.size).map!{Array.new(@times.size).map!{Array.new(@weeks.size + 1).map!{Array.new}}}
      pairs.each do |pair|
        @pairs[pair.day_of_the_week - 1][pair.pair_number - 1][pair.week] << pair
      end
    end
  end

end
