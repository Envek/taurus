class Department::ChargeCardFormsController < Department::BaseController

  def show
    @disciplines = Discipline.includes(charge_cards: {teaching_place: :lecturer, jets: :group}).where(department_id: current_department.id, charge_cards: {semester_id: current_semester.id}).order('disciplines.name')
    @lesson_types = LessonType.all
    @grouped = Hash[@disciplines.map do |discipline|
      lect_cards = discipline.charge_cards.select{|c| c.lesson_type_id == 1}.sort_by{|c| c.groups.first.try(:course)}
      cards = discipline.charge_cards.reject{|c| c.lesson_type_id == 1}
      groups = lect_cards.map do |card|
        pl_cards = cards.select{|c| (c.groups - card.groups).empty? }.group_by{|c| [c.group_ids, c.teaching_place_id]}
        cards.reject!{|c| (c.groups - card.groups).empty? }
        [card, pl_cards]
      end
      other_card_groups = cards.group_by{|c| [c.group_ids, c.teaching_place_id]}.map do |g, cs|
        [cs.first, [[g, cs]]]
      end
      [discipline.id, groups + other_card_groups]
    end]
  end

end
