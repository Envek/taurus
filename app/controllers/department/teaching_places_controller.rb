# -*- encoding : utf-8 -*-
class Department::TeachingPlacesController < Department::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:position, :lecturer]
    config.list.columns = [:lecturer, :position]
    #config.columns[:lecturer].form_ui = :select
    config.columns[:lecturer].clear_link
    config.columns[:position].form_ui = :select
    config.columns[:lecturer].sort_by :sql => 'lecturers.name'
    config.search.columns = :lecturer
    config.columns[:lecturer].search_sql = 'lecturers.name'
    config.nested.add_link :charge_cards
    config.action_links.add :training_assignments, label: 'Заявка на учебные поручения', page: true, type: :member
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
  end

  protected

  def before_create_save(record)
    @dept ||= current_department
    record.department_id = @dept.id
  end

  # Records are filtered according to CanCan abilities.

end
