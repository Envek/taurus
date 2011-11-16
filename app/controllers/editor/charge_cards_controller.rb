class Editor::ChargeCardsController < Editor::BaseController
  def index
    charge_card_search = params[:charge_card].to_s.split
    charge_card = ChargeCard.all(:select => "id,editor_name")
    charge_card_search.each do |s|
        charge_card = charge_card.select { |c| c.editor_name.include? s if c.editor_name}
    end
    respond_to do |format|
      format.json { render :json => charge_card.to_json(:only => [:id], :methods => [:editor_name])}
    end
  end
end
