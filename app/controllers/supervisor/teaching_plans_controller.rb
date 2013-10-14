# -*- encoding : utf-8 -*-
class Supervisor::TeachingPlansController < Supervisor::BaseController

  include GosinspParser

  def new
  end

  def fill
    if params[:plan] and params[:plan].class == ActionDispatch::Http::UploadedFile
      params[:plan].rewind # In case if someone have already read our file
      @speciality, @results, @errors = parse_and_fill_teaching_plan(params[:plan].read)
    end
  end

end
