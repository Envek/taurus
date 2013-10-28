# -*- encoding : utf-8 -*-
module SpecialitiesTeachingPlansConcern
  extend ActiveSupport::Concern

  include GosinspParser

  included do
    if defined? active_scaffold_config and active_scaffold_config
      active_scaffold_config.action_links.add :teaching_plan, :label => "Учебный план", :type => :member, :page => true
      active_scaffold_config.action_links.add :teaching_plan_import, :label => "Импорт учебного плана", :type => :collection, :page => true
    end
  end

  def teaching_plan
    @speciality = Speciality.find(params[:id])
    @teaching_plans = TeachingPlan.where(speciality_id: @speciality.id)
    @courses = @teaching_plans.uniq.reorder(:course).pluck(:course)
    @display_courses = params[:course].present? ? [params[:course].to_i] : @courses
    @teaching_plans = @teaching_plans.where(course: params[:course]) if params[:course].present?
    discipline_ids = @teaching_plans.map{|tp| tp.discipline_id}.uniq
    @disciplines = Discipline.reorder(:name).includes(:department).find(discipline_ids)
    render "application/specialities/teaching_plans/show"
  end

  def teaching_plan_import
    if params[:plan] and params[:plan].class == ActionDispatch::Http::UploadedFile
      @specialities = can?(:manage, :all) ? nil : Speciality.accessible_by(current_ability, :update)
      params[:plan].rewind # In case if someone have already read our file
      @speciality, @results, @errors = parse_and_fill_teaching_plan(params[:plan].read, @specialities)
      render "application/specialities/teaching_plans/fill"
      return
    end
    render "application/specialities/teaching_plans/new"
  end

end