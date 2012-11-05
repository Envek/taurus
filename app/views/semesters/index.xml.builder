xml.instruct!

xml.semesters do |semesters|
	@semesters.each do |semester|
		xml.semester (semester.to_human,
			:year => semester.year,
			:number => semester.number,
			:full_time => semester.full_time,
			:start => semester.start,
			:end => semester.end
		)
	end
end
