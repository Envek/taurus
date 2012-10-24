class Supervisor::ChargeCardsController < ApplicationController
  active_scaffold :charge_card do |conf|
    conf.actions << :delete
    conf.columns = [:teaching_place, :assistant_teaching_place, :lesson_type, :jets, :discipline, :hours_quantity, :hours_per_week, :weeks_quantity, :groups]
    conf.create.columns.exclude :groups, :hours_quantity
    conf.update.columns.exclude :groups, :hours_quantity
    conf.list.columns.exclude :jets
    conf.columns[:discipline].form_ui = :record_select
    conf.columns[:lesson_type].form_ui = :select
    conf.columns[:lesson_type].inplace_edit = true
    conf.columns[:teaching_place].form_ui = :select
    conf.columns[:teaching_place].clear_link
    conf.columns[:assistant_teaching_place].form_ui = :select
    conf.columns[:assistant_teaching_place].clear_link
    conf.columns[:discipline].clear_link
    conf.columns[:groups].clear_link
    conf.columns[:hours_per_week].inplace_edit = true
    conf.columns[:weeks_quantity].inplace_edit = true
  end

  def conditions_for_collection
    {:semester_id => current_semester.id}
  end

protected

  def do_new
    super
    @record.semester = current_semester
  end

end 