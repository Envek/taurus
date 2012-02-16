class Editor::Groups::GroupsController < Editor::BaseController

  def index
    flash[:error] = nil
    session[:group_editor] = {:groups => []} unless session[:group_editor]
    @group = Group.find(params[:group_id]) if params[:group_id]
    except = params[:except] ? params[:except].split(',').map { |e| e.to_i } : "0"
    classroom = params[:group].to_s.gsub('%', '\%').gsub('_', '\_') + '%'
    @groups = Group.all(:conditions => ['id NOT IN (?) AND name LIKE ?', except, classroom], :select => "id, name")
    respond_to do |format|
      format.html
      format.json { render :json => @groups }
    end
  end

  def show
    @days = Timetable.days
    @times = Timetable.times
    @weeks = Timetable.weeks
    @group = Group.for_groups_editor.find(params[:id])
    unless @group
      flash[:error] = 'Нет группы с таким названием'
    else
      session[:group_editor] = {:groups => []} unless session[:group_editor]
      session[:group_editor][:groups] << @group.id unless session[:group_editor][:groups].include? @group.id
      @groups = session[:group_editor][:groups]
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
    if session[:group_editor].include? :groups
      @id = params[:id].to_i
      session[:group_editor][:groups].delete(@id)
      @groups = session[:group_editor][:groups]

      respond_to do |format|
        format.js
      end
    end
  end
  
end
