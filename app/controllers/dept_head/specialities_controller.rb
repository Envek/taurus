class DeptHead::SpecialitiesController < DeptHead::BaseController
  include GosinspParser

  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name]
    config.nested.add_link('Группы', [:groups])
    config.action_links.add :teaching_plan, :label => "Учебный план", :type => :member, :page => true
    config.action_links.add :teaching_plan_import, :label => "Импорт учебного плана", :type => :collection, :page => true
  end

  def teaching_plan
    @speciality = Speciality.find(params[:id])
    @teaching_plans = TeachingPlan.find_all_by_speciality_id(@speciality.id)
    discipline_ids = @teaching_plans.map{|tp| tp.discipline_id}.uniq
    @disciplines = Discipline.find(discipline_ids, :order => :name)
    @courses = @teaching_plans.map{|tp| tp.course}.uniq.sort
    render "application/specialities/teaching_plans/show"
  end

  def teaching_plan_import
    if params[:plan] and params[:plan].class == Tempfile
      @specialities = current_dept_head.department.specialities
      @speciality, @results, @errors = parse_and_fill_teaching_plan(params[:plan].read, @specialities)
      render "supervisor/teaching_plans/fill"
      return
    end
  end

  protected

  def before_create_save(record)
    if dept = current_dept_head.department
      record.department_id = dept.id
    end
  end

  def conditions_for_collection
    if dept = current_dept_head.department
      {:department_id => dept.id}
    else
      {:department_id => nil}
    end
  end
end
