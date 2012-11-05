xml.instruct!

xml.pairs(:group => @group.name, :semester_id => @current_semester.id, :semester => @current_semester) do |pairs|
	@pairs.flatten.each_slice(2).each do |pair, subgroup|
		xml.pair (
			:day_of_the_week => pair.day_of_the_week,
			:pair_number => pair.pair_number,
			:week => pair.week,
			:subgroup => subgroup
		) do |pair_node|
			xml.discipline (pair.discipline, :short_name => pair.short_discipline)
			if pair.classroom
				xml.classroom (pair.classroom.full_name, 
					:name => pair.classroom.name,
					:building => pair.classroom.building.try(:name)
				)
			end
			xml.lecturer (pair.lecturer_full,
				:short_name => pair.lecturer,
				:name => pair.try(:charge_card).try(:teaching_place).try(:lecturer).try(:name),
				:department => pair.try(:charge_card).try(:teaching_place).try(:department).try(:name)
			)
			if pair.try(:charge_card).try(:assistant_teaching_place)
				xml.assistant (pair.assistant_full,
					:short_name => pair.assistant,
					:name => pair.try(:charge_card).try(:assistant_teaching_place).try(:lecturer).try(:name),
					:department => pair.try(:charge_card).try(:assistant_teaching_place).try(:department).try(:name)
				)
			end
		end
	end
end
