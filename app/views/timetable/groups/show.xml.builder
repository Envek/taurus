xml.instruct!

xml.pairs(:group => @group.name, :semester_id => @current_semester.id, :semester => @current_semester) do |pairs|
	@pairs.flatten.each_slice(2).each do |pair, subgroup|
		xml.pair (
			:day_of_the_week => pair.day_of_the_week,
			:pair_number => pair.pair_number,
			:week => pair.week,
			:subgroup => subgroup,
			:classroom => pair.classroom.name,
			:discipline => pair.short_discipline,
			:discipline_full => pair.discipline,
			:lecturer => pair.lecturer,
			:lecturer_full => pair.lecturer_full,
			:assistant => pair.assistant,
			:assistant_full => pair.assistant_full
		)
	end
end