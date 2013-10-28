# -*- encoding : utf-8 -*-
class Faculty::TrainingAssignmentsController < Faculty::BaseController
  include TrainingAssignmentsConcern

  protected

  # Method from concern doesn't work, it's duplicate
  # TODO: Make concern's method to work and remove
  def do_new
    super
    @record.semester = current_semester
  end

end
