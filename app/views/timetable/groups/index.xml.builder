xml.instruct!

xml.groups(:semester_id => @current_semester.id, :semester => @current_semester) do |pairs|
	@groups.each do |group|
		xml.group (
			:name => group.name,
			:speciality => ("#{group.speciality.code} — #{group.speciality.name}" if group.speciality),
			:faculty => (group.speciality.department.try(:faculty).try(:name) if group.speciality),
			:course => group.course
		)
	end
end
