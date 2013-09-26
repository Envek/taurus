# -*- encoding : utf-8 -*-
class Supervisor::ChargeCardsController < ApplicationController
  active_scaffold :charge_card do |conf|
    conf.actions << :delete
    conf.columns = [:teaching_place, :assistant_teaching_place, :lesson_type, :jets, :discipline, :hours_quantity, :hours_per_week, :weeks_quantity, :groups, :preferred_classrooms, :note]
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
    conf.columns[:note].inplace_edit = true
  end

  def conditions_for_collection
    {:semester_id => current_semester.id}
  end

protected

  def do_new
    super
    @record.semester = current_semester
  end

  # It's a hack, that allows to change groups in charge card edit.
  # TODO: Remove it after bugfix in active_scaffold 
  def before_update_save(record)
    if params[:record].present?
      record.preferred_classroom_ids = params[:record][:preferred_classrooms]
      record.jets.each do |jet|
        jet.save if jet.group_id_changed?
      end
    end
  end

end 
