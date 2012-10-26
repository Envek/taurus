class Editor::Reference::GroupsListsController < Editor::BaseController
  before_filter :get_groups_list

  def new
  end

  def show
    @days = Timetable.days
    @times = Timetable.times
    @weeks = Timetable.weeks
    @pairs = []
    @groups.each do |group|
      @pairs << group.get_pairs(@current_semester)
    end
  end

  def index
  end

  private

  def get_groups_list
    session[:groups_lists] = {:groups => []} unless session[:groups_lists]
    @groups = Group.for_timetable.where(:id => session[:groups_lists][:groups])
  end
end

