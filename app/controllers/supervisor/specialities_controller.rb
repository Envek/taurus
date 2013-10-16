# -*- encoding : utf-8 -*-
class Supervisor::SpecialitiesController < Supervisor::BaseController
  active_scaffold do |config|
    config.actions << :delete
    config.columns = [:code, :name, :department]
    config.nested.add_link :groups
    config.columns[:department].form_ui = :select
    config.action_links.add :teaching_plan, :label => "Учебный план", :type => :member, :page => true
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

end
