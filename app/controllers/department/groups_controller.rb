# -*- encoding : utf-8 -*-
class Department::GroupsController < Department::BaseController
  before_filter :customize_active_scaffold
  record_select :search_on => :name, :order_by => :name
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:name, :forming_year, :course, :population]
    config.create.columns.exclude :course
    config.update.columns.exclude :course
    config.action_links.add :teaching_plan, :label => "Учебный план", :type => :member, :page => true
  end

  def teaching_plan
    @group = Group.find(params[:id])
    @charge_cards = @group.charge_cards.where(:semester_id => current_semester.id)
    @lesson_types = LessonType.all(:order => :id)
    @teaching_plans = TeachingPlan.find_all_by_speciality_id_and_course_and_semester(
      @group.speciality_id, @group.course, current_semester.number
    )
    discipline_ids = (@charge_cards.map{|cc| cc.discipline_id} + @teaching_plans.map{|tp| tp.discipline_id}).uniq
    @disciplines = Discipline.find(discipline_ids, :order => :name)
    render "application/groups/teaching_plans/show"
  end

protected

  def customize_active_scaffold
    actions = [:create, :update, :delete]
    config  = active_scaffold_config
    if nested? and nested_parent_record.department_id != current_department.id
      actions.each do |action|
        config.actions.exclude action
      end
    else
      actions.each do |action|
        config.actions << action
      end
    end
  end

end
