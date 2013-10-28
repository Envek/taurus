# -*- encoding : utf-8 -*-
module TrainingAssignmentsConcern
  extend ActiveSupport::Concern

  included do
    active_scaffold :training_assignment do |conf|
      conf.actions << :delete
      conf.columns = [:disciplines, :groups, :weeks_quantity, :lesson_type, :hours, :semester_id]
      conf.list.columns = [:disciplines, :groups, :weeks_quantity, :lesson_type, :hours, :hours_per_week]
      conf.columns[:disciplines].form_ui = :record_select
      conf.columns[:disciplines].clear_link
      conf.columns[:disciplines].search_sql = 'disciplines.name||disciplines.short_name'
      conf.columns[:disciplines].sort_by sql: 'disciplines.name'
      conf.search.columns << :disciplines
      conf.columns[:groups].form_ui = :record_select
      conf.columns[:groups].clear_link
      conf.columns[:groups].search_sql = 'groups.name'
      conf.columns[:groups].sort_by sql: 'groups.name'
      conf.search.columns << :groups
      conf.columns[:lesson_type].form_ui = :select
      conf.columns[:lesson_type].inplace_edit = true
      conf.columns[:lesson_type].clear_link
      conf.columns[:lesson_type].search_sql = 'lesson_types.name'
      conf.columns[:lesson_type].sort_by sql: 'lesson_types.name'
      conf.search.columns << :lesson_type
      conf.columns[:lesson_type].search_ui = :select
      conf.columns[:weeks_quantity].inplace_edit = true
      conf.columns[:hours].inplace_edit = true
      conf.columns[:semester_id].form_ui = :hidden
      conf.actions.add :mark
      conf.action_links.add :join_selected, type: :collection, position: false
      conf.action_links.add :report, type: :collection, position: false, page: true
      conf.action_links.add :split_by_disciplines, type: :member, position: false
      conf.action_links.add :split_by_groups, type: :member, position: false
    end

    before_filter :load_assignments, only: [:report, :new_charge_cards, :create_charge_cards]
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

  def report
    @lesson_types = LessonType.all
    @disciplines = @assignments.map(&:disciplines).flatten.uniq.sort_by(&:name)
    @grouped_assignments = @assignments.group_by{|ta| ta.disciplines.sort_by(&:id) }.sort do |a,b|
      a.first.first.try(:name).to_s <=> b.first.first.try(:name).to_s
    end.map do |disciplines, assignments|
      lect_assigns = assignments.select{|c| c.lesson_type_id == 1}.sort_by{|c| c.groups.map(&:course).min }
      other_assigns = assignments.reject{|c| c.lesson_type_id == 1}
      lect_groups = lect_assigns.map do |assignment|
        pl_assigns = other_assigns.select{|a| (a.groups - assignment.groups).empty? }.group_by{|a| a.group_ids.sort }
        other_assigns.reject!{|a| (a.groups - assignment.groups).empty? }
        [assignment, pl_assigns]
      end
      other_groups = other_assigns.group_by{|a| a.group_ids.sort }.map do |g, as|
        [as.first, [[g, as]]]
      end
      [disciplines, lect_groups + other_groups]
    end
    render '/application/training_assignments/report'
  end

  def new_charge_cards
    find_cards_to_create_and_cards_to_remove
    render '/application/training_assignments/new_charge_cards'
  end

  def create_charge_cards
    find_cards_to_create_and_cards_to_remove(true)
    ChargeCard.transaction do
      @cards_to_create.each do |card|
        card.jets.each do |jet|
          jet.save or card.jets.destroy(jet)
        end
        card.save!
      end
      @cards_to_remove.each do |card|
        card.destroy!
      end if params[:remove_old_cc]
    end
    redirect_to url_for(action: 'report'), :notice => "Создано карт нагрузок: #{@cards_to_create.size}#{", удалено: #{@cards_to_remove.size}" if params[:remove_old_cc]}"
  end

  def conditions_for_collection
    {:semester_id => current_semester.id}
  end

  protected

  def load_assignments
    @assignments = TrainingAssignment.joins(:disciplines).includes(:disciplines).where(semester_id: current_semester.id)
    if params[:department_id].present?
      @department  = Department.includes(:disciplines).find(params[:department_id])
      @assignments = @assignments.where(disciplines: {id: @department.discipline_ids})
    end
    if params[:faculty_id].present?
      @faculty = Faculty.includes(departments: {specialities: :groups}).find(params[:faculty_id])
      group_ids = @faculty.departments.map(&:specialities).flatten.map(&:group_ids).flatten
      @assignments = @assignments.includes(:groups).where(groups: {id: group_ids})
    end
  end

  def find_cards_to_create_and_cards_to_remove(allow_changes=false)
    # Find all charge cards, that will be created
    @cards_to_create = @assignments.map do |a|
      conditions = {lesson_type_id: a.lesson_type_id, jets: {group_id: a.group_ids}, disciplines: {id: a.discipline_ids}, semester_id: a.semester_id}
      charge_card = ChargeCard.includes([{jets: :group}, :disciplines, :lesson_type]).where(conditions).first_or_initialize
      # Add missing disciplines to charge card
      charge_card.disciplines(true) # Reload association as not all disciplines may be loaded due to join
      (Set.new(a.discipline_ids.sort) ^ Set.new(charge_card.discipline_ids.sort)).each do |discipline_id|
        if allow_changes
          charge_card.disciplines << Discipline.find(discipline_id)
        else
          charge_card.disciplines.build(a.disciplines.select{|d| d.id == discipline_id }.first.attributes)
        end
      end
      # Add missing groups to charge card
      (Set.new(a.group_ids.sort) ^ Set.new(charge_card.jets(true).map(&:group_id).sort)).each do |group_id|
        charge_card.jets.build(group_id: group_id, subgroups_quantity: 0)
      end
      charge_card.weeks_quantity = a.weeks_quantity
      charge_card.hours_per_week = a.hours_per_week
      charge_card
    end
    # Find all charge cards, that will be deleted
    to_remove_conditions = {semester_id: current_semester.id}
    to_remove_conditions.merge!(disciplines: {id: @department.discipline_ids}) if @department
    if @faculty
      group_ids = @faculty.departments.map(&:specialities).flatten.map(&:group_ids).flatten
      to_remove_conditions.merge!(jets: {group_id: group_ids})
    end
    @cards_to_remove = (ChargeCard.includes([{jets: :group}, :disciplines, :lesson_type]).where(to_remove_conditions) - @cards_to_create)
  end

  def do_new
    super
    debugger
    @record.semester = current_semester
  end

end
