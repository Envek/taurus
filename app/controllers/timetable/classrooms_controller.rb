class Timetable::ClassroomsController < Timetable::BaseController

  def index
    @buildings = Building.includes(:classrooms).reorder("buildings.id,(substring(classrooms.name, '^[0-9]+'))::int,substring(classrooms.name, '[^0-9_].*$')")
    @buildings = @buildings.where("classrooms.name ILIKE ? OR classrooms.title ILIKE ? OR buildings.name ILIKE ?", *(["%#{params[:classroom]}%"]*3)) if params[:classroom]
    if params[:day_of_the_week] and params[:week] and params[:pair_number]
      week_filter = params[:week] == '0' ? [0,1,2] : [params[:week], 0]
      unwanted_classroom_ids = Pair.where(week: week_filter, day_of_the_week: params[:day_of_the_week], pair_number: params[:pair_number]).pluck(:classroom_id).uniq.compact
      if unwanted_classroom_ids.any?
        @buildings = @buildings.where("classrooms.id NOT IN (#{unwanted_classroom_ids.join(",")})")
      end
    end
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
