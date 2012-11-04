xml.instruct!

xml.groups(:semester_id => @current_semester.id, :semester => @current_semester) do |pairs|
	@groups.each do |group|
		xml.group (
			:name => group.name
		)
	end
end