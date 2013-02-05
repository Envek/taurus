# -*- encoding : utf-8 -*-
class Department::SpecialitiesController < Department::BaseController
  include GosinspParser

  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name]
    config.nested.add_link(:groups)
    config.action_links.add :teaching_plan, :label => "Учебный план", :type => :member, :page => true
    config.action_links.add :teaching_plan_import, :label => "Импорт учебного плана", :type => :collection, :page => true
    config.action_links.add :add_charge_cards, :label => "Автосоздание карт нагрузки", :type => :member, :page => true
  end

  def teaching_plan
    @speciality = Speciality.find(params[:id])
    @teaching_plans = TeachingPlan.find_all_by_speciality_id(@speciality.id)
    discipline_ids = @teaching_plans.map{|tp| tp.discipline_id}.uniq
    @disciplines = Discipline.order("name").find(discipline_ids)
    @courses = @teaching_plans.map{|tp| tp.course}.uniq.sort
    render "application/specialities/teaching_plans/show"
  end

  def teaching_plan_import
    if params[:plan] and params[:plan].class == ActionDispatch::Http::UploadedFile
      @specialities = current_department.specialities
      @speciality, @results, @errors = parse_and_fill_teaching_plan(params[:plan].read, @specialities)
      render "supervisor/teaching_plans/fill"
      return
    end
  end

  def add_charge_cards
    @speciality = Speciality.find(params[:id])
    discipline_ids = current_department.disciplines.select("id").map{|d| d.id}
    to_remove_ids = @speciality.groups.map{|g| g.jets}.flatten.map{|j| j.charge_card_id}.uniq
    @cards_to_remove = ChargeCard.where(:id => to_remove_ids, :discipline_id => discipline_ids, :semester_id => current_semester.id).count
    # List all charge cards to be created
    @cards_to_create = []
    conditions = {:speciality_id => @speciality.id, :discipline_id => discipline_ids}
    @courses = TeachingPlan.where(:speciality_id => @speciality.id).select("DISTINCT(course)").map{|p| p.course}.sort
    @courses.each do |course|
      groups = @speciality.groups.select{|g| g.course_in(current_semester) == course}
      if groups.any?
        conditions.merge!({:course => course, :semester => current_semester.number})
        plans = TeachingPlan.where(conditions).all
        plans.each do |plan|
          if plan.lections
            card = ChargeCard.new(:discipline_id => plan.discipline_id, :lesson_type_id => 1, :semester_id => current_semester.id)
            card.weeks_quantity = 18
            card.hours_per_week = plan.lections / 18
            card.groups = groups unless card.groups == groups
            @cards_to_create << card
          end
          if plan.practics
            groups.each do |group|
              card = ChargeCard.new(:discipline_id => plan.discipline_id, :lesson_type_id => 2, :semester_id => current_semester.id)
              card.weeks_quantity = 18
              card.hours_per_week = plan.practics / 18
              card.groups = [group] unless card.groups == [group]
              @cards_to_create << card
            end
          end
          if plan.lab_works
            groups.each do |group|
              card = ChargeCard.new(:discipline_id => plan.discipline_id, :lesson_type_id => 3, :semester_id => current_semester.id)
              card.weeks_quantity = 18
              card.hours_per_week = plan.lab_works / 18
              card.groups = [group] unless card.groups == [group]
              @cards_to_create << card
            end
          end
        end
      end
    end
  end

  def create_charge_cards
    @speciality = Speciality.find(params[:id])
    discipline_ids = current_department.disciplines.select("id").map{|d| d.id}
    conditions = {:speciality_id => @speciality.id, :discipline_id => discipline_ids}
    if params[:remove]
      ids = @speciality.groups.map{|g| g.jets}.flatten.map{|j| j.charge_card_id}.uniq
      deleted = (ChargeCard.destroy_all(:id => ids, :discipline_id => discipline_ids, :semester_id => current_semester.id)).count
    end
    created = 0
    @courses = TeachingPlan.where(:speciality_id => @speciality.id).select("DISTINCT(course)").map{|p| p.course}.sort
    @courses.each do |course|
      groups = @speciality.groups.select{|g| g.course_in(current_semester) == course}
      if groups.any?
        conditions.merge!({:course => course, :semester => current_semester.number})
        plans = TeachingPlan.where(conditions).all
        plans.each do |plan|
          created += (plan.create_charge_cards_for(groups, current_semester)).count
        end
      end
    end
    redirect_to "/department/#{params[:department_id]}/specialities", :notice => "Создано карт нагрузок: #{created}#{", удалено: #{deleted}" if deleted}"
  end

  protected

  def before_create_save(record)
    record.department_id = current_department.id
  end

end
