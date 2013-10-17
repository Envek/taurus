# -*- encoding : utf-8 -*-
class Supervisor::TrainingAssignmentsController < Supervisor::BaseController
  active_scaffold :training_assignment do |conf|
    conf.actions << :delete
    conf.columns = [:disciplines, :groups, :weeks_quantity, :lesson_type, :hours, :hours_per_week]
    conf.columns[:disciplines].form_ui = :record_select
    conf.columns[:disciplines].clear_link
    conf.columns[:disciplines].search_sql = 'disciplines.name||disciplines.short_name'
    conf.search.columns << :disciplines
    conf.columns[:groups].form_ui = :record_select
    conf.columns[:groups].clear_link
    conf.columns[:groups].search_sql = 'groups.name'
    conf.search.columns << :groups
    conf.columns[:lesson_type].form_ui = :select
    conf.columns[:lesson_type].inplace_edit = true
    conf.columns[:lesson_type].clear_link
    conf.columns[:lesson_type].search_sql = 'lesson_types.name'
    conf.search.columns << :lesson_type
    conf.columns[:lesson_type].search_ui = :select
    conf.columns[:weeks_quantity].inplace_edit = true
    conf.columns[:hours].inplace_edit = true
    conf.actions.add :mark
    conf.action_links.add :join_selected, type: :collection, position: false
    conf.action_links.add :split_by_disciplines, type: :member, position: false
    conf.action_links.add :split_by_groups, type: :member, position: false
  end

  def join_selected
    TrainingAssignment.transaction do
      grouped = each_marked_record.group_by{|r| [r.lesson_type_id, r.weeks_quantity, r.hours]}
      total = each_marked_record.count
      after = grouped.size
      grouped.each do |grouped_params, records|
        record = records.first
        record.disciplines = records.map(&:disciplines).flatten.uniq
        record.groups = records.map(&:groups).flatten.uniq
        record.save
        record.as_marked = false
        records[1..-1].each do |record|
          record.as_marked = false
          record.destroy
        end
      end
      flash[:info] = "Объединено #{total} записей в #{after}!"
    end
    list
  end

  def split_by_groups
    TrainingAssignment.transaction do
      total = 1
      record = find_if_allowed(params[:id], :update)
      success = true
      record.groups.each.with_index do |group, index|
        unless index.zero?
          r = record.dup(include: :disciplines)
          r.groups = [group]
          success &&= r.save
          total += 1
        end
      end
      record.groups = [record.groups.first]
      self.successful = record.save && success
      flash[:info] = "Запись разделена на #{total} по группам!"
    end
    list
  end

  def split_by_disciplines
    TrainingAssignment.transaction do
      total = 1
      record = find_if_allowed(params[:id], :update)
      success = true
      record.disciplines.each.with_index do |discipline, index|
        unless index.zero?
          r = record.dup(include: :groups)
          r.disciplines = [discipline]
          success &&= r.save
          total += 1
        end
      end
      record.disciplines = [record.disciplines.first]
      self.successful = record.save && success
      flash[:info] = "Запись разделена на #{total} по дисциплинам!"
    end
    list
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
