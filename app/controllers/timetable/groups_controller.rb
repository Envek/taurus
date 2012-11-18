class Timetable::GroupsController < Timetable::BaseController

  def index
    @groups = Group.includes(:speciality => {:department => :faculty})\
                  .joins(:subgroups => {:pair => :charge_card}, :speciality => {:department => :faculty})\
                  .where(:subgroups => {:pairs => {:charge_cards => {:semester_id => @current_semester.id}}})\
                  .order(:name).uniq
    @groups = @groups.by_name(params[:group]) if params[:group]
    respond_to do |format|
      format.html do
        if params[:group] and @groups.count == 1 
          redirect_to timetable_group_path(@groups.first)
        end
        # Caching management
        index_modify_timestamp = [Group.maximum(:updated_at), Pair.joins(:charge_card).where(:charge_cards => {:semester_id => @current_semester.id}).maximum(:updated_at)].compact.max.utc
        response.headers['Last-Modified'] = @terminal ? Time.now.utc.httpdate : index_modify_timestamp.httpdate
        expires_in (@terminal ? 1.minute : 1.day), :public => true
      end
      format.xml
      format.json do
        render :json => @groups.to_json(:only => [:name], :methods => [:course], :include => {
          :speciality => {:only => [:code, :name], :include => {
            :department => {:only => [], :include => {
              :faculty => {:only => :name}
            }}
          }}
        })
      end
    end    
  end
  
  def show
    begin
      @group = Group.for_timetable.from_param(params[:id])
    rescue ActiveRecord::RecordNotFound
      # Not found? Well, may be this is old bookmarked address? Try find by id.
      @group = Group.for_timetable.find(params[:id])
      redirect_to timetable_group_path(@group), :status => 301, :notice => "Вы зашли на эту страницу по устаревшей ссылке! Обновите закладки в вашем браузере! Правильная ссылка: #{self.class.helpers.link_to(URI.unescape(timetable_group_url(@group)), timetable_group_path(@group))}".html_safe
      expires_in 1.year, :public => true
      return
    end
    @days = Timetable.days
    @times = Timetable.times
    @weeks = Timetable.weeks
    @pairs = @group.get_pairs(current_semester)
    respond_to do |format|
      format.html
      format.xml
      format.json
      format.xlsx do
        render :xlsx => 'show', :filename => "Расписание занятий группы #{@group.name}.xlsx"
      end
    end
  end
end
