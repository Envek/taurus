# -*- encoding : utf-8 -*-
class HelpController < ApplicationController
  layout 'timetable'

  def show
    help_pages = Dir.glob(Rails.root+"app/views/help/**/*.md*")
    requested_file = Rails.root+"app/views/help/"+(params[:page])
    unless help_pages.any? { |page| page.starts_with? requested_file.to_s }
      raise ActiveRecord::RecordNotFound
    else
      @page = params[:page]
      @page += "/index" if (Rails.root+"app/views/help/"+params[:page]).directory?
      @content = render_to_string(:template => "help/#{@page}", :formats => [:md])
      respond_to do |format|
        format.html
        format.any(:markdown, :text) do
          render :text => @content
        end
      end
    end
  end

end
