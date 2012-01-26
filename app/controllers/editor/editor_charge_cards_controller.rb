class Editor::EditorChargeCardsController < Editor::BaseController
  def index
    charge_card_search = params[:charge_card].to_s.split
    classroom = Classroom.find(params[:classroom_id])
    if classroom.department_lock and classroom.department
      charge_card = ChargeCard.all :joins => :teaching_place, 
        :conditions => {:teaching_places => {:department_id => classroom.department.id}}
    else
      charge_card = ChargeCard.all(:select => "id,editor_name")
    end
    charge_card_search.each do |s|
      charge_card = charge_card.select { |c| c.editor_name_include? s }
    end
    charge_card.sort! {|a,b| a.editor_name <=> b.editor_name}
    respond_to do |format|
      format.json { render :json => charge_card.to_json(:only => [:id], :methods => [:editor_name])}
    end
  end
end
