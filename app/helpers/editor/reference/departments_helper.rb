# -*- encoding : utf-8 -*-
module Editor::Reference::DepartmentsHelper
  def department_charge_cards_all_column(record, column)
    ChargeCard.joins(:discipline).where(semester_id: current_semester.id, disciplines: {department_id: record.id}).count
  end

  def department_charge_cards_today_column(record, column)
    ChargeCard.joins(:discipline).where(semester_id: current_semester.id, disciplines: {department_id: record.id}).where('"charge_cards"."created_at"::date = ?',Date.today).count
  end
end
