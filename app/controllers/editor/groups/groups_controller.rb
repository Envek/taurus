class Editor::Groups::GroupsController < Editor::BaseController

  def index
    flash[:error] = nil
    request.xhr? ? nil : cookies[:groups] = YAML.dump([0])
    @group_id = params[:group_id].to_i unless params[:group_id].nil?
    except = params[:except] ? params[:except].split(',').map { |e| e.to_i } : "0"
    classroom = params[:group].to_s.gsub('%', '\%').gsub('_', '\_') + '%'
    @groups = Group.all(:conditions => ['id NOT IN (?) AND name LIKE ?', except, classroom], :select => "id, name")
    # If group id specified, show it's grid immediately
    if @group_id
      @group = Group.find(@group_id, :include => {:jets => {:charge_card => :pairs}})
      @days = Timetable.days
      @times = Timetable.times
      @weeks = Timetable.weeks
      unless @group
        flash[:error] = 'Нет группы с таким названием'
      else
        @pairs = @group.jets.map {|j| j.charge_card.pairs}.flatten
      end
    end
    respond_to do |format|
      format.html
      format.json { render :json => @groups }
    end
  end

  def show
    @days = Timetable.days
    @times = Timetable.times
    @weeks = Timetable.weeks
    @group = Group.find(params[:id], :include => {:jets => {:charge_card => :pairs}})
    unless @group
      flash[:error] = 'Нет группы с таким названием'
    else
      @pairs = @group.jets.map {|j| j.charge_card.pairs}.flatten
      grids = YAML.load(cookies[:groups])
      grids << @group.id
      cookies[:groups] = YAML.dump(grids)
      @groups = YAML.load(cookies[:groups])

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
    @id = params[:id]
    grids = YAML.load(cookies[:groups])
    grids.delete(@id.to_i)
    cookies[:groups] = YAML.dump(grids)
    @groups = YAML.load(cookies[:groups])

    respond_to do |format|
      format.js
    end
  end
  
end
