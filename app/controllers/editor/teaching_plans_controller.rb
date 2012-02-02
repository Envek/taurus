class Editor::TeachingPlansController < Editor::BaseController

  def index
    @groups = Group.all(:order => :name)
  end
  
  def show
    @group = Group.find(params[:group_id])
    @charge_cards = @group.charge_cards
    @disciplines = Discipline.find(@charge_cards.map{|cc| cc.discipline_id}, :order => :name)
    @lesson_types = LessonType.all(:order => :id)
  end

end
