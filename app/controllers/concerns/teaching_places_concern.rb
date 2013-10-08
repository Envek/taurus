# -*- encoding : utf-8 -*-
module TeachingPlacesConcern
  extend ActiveSupport::Concern

  included do
    active_scaffold_config.action_links.add :training_assignments, label: 'Заявка на учебные поручения', page: true, type: :member
  end

  def training_assignments
    cc_includes = [:discipline, {jets: :group}]
    @teaching_place = TeachingPlace.includes(charge_cards: cc_includes, assistant_charge_cards: cc_includes).find(params[:id])
    @charge_cards = [@teaching_place.charge_cards.where(charge_cards: {semester_id: current_semester}) + @teaching_place.assistant_charge_cards.where(charge_cards: {semester_id: current_semester})].flatten.uniq
    disciplines = [@teaching_place.charge_cards.map(&:discipline) + @teaching_place.assistant_charge_cards.map(&:discipline)].flatten.compact.uniq.sort_by(&:name)
    @grouped = []
    disciplines.each do |discipline|
      cc = @charge_cards.select{|cc| cc.discipline_id == discipline.id}
      groups = cc.map{|c| c.jets.map(&:group)}.flatten.uniq.sort
      groups.each do |group|
        cards = cc.select{|c| c.jets.map(&:group_id).include? group.id }
        @grouped << [discipline, group, cards] if cards.any?
      end
    end
    @lesson_types = LessonType.all
    respond_to do |format|
      format.html { render 'department/teaching_places/training_assignments' }
      format.xlsx { render xlsx: '/department/teaching_places/training_assignments', filename: "Заявка на учебные поручения: #{@teaching_place.try(:lecturer).try(:short_name)}, кафедра #{current_department.short_name}.xlsx" }
    end
  end

end