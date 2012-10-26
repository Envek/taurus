module Timetable::BaseHelper

  def pair_plaintext(pair, subgroup)
    if pair.is_a? Pair
      "#{pair.lecturer}#{", "+pair.assistant if pair.assistant}\r\n\
#{pair.discipline}\r\n\
Ауд.: #{pair.classroom ? "#{pair.classroom.name} (#{pair.classroom.building.name})" : "не указана"}\r\n\
#{"Подгруппа #{subgroup}\r\n" if subgroup and pair.max_subgroups > 2}\
#{"с #{pair.active_at} по #{pair.expired_at}" if ![1,2,9].include?(pair.active_at.month) or ![5,6,12].include?(pair.expired_at.month)}"
    end
  end

end
