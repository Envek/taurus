class SemestersController < ApplicationController

	def index
		@semesters = Semester.all
		respond_to do |format|
			format.xml
			format.json
		end
	end

end
