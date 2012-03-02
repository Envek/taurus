# encoding: UTF-8
module GosinspParser

  def parse_and_fill_teaching_plan(file_plan_contents, allowed_specialities = nil)
    plan = Nokogiri::XML(file_plan_contents)
    errors = []
    results = []
    # Check, is it correct plan
    if    plan.at_css("Документ>План>Титул").nil? \
       or plan.at_css("Документ")["Тип"] != "рабочий учебный план" \
       or plan.at_css("Документ>План")["ПодТип"] != "рабочий учебный план"
        return nil, [], ["Данный файл не является файлом учебного плана! Принимаются только планы в формате .PL*.XML."]
    else
      suffix = case plan.at_css("Документ>План")["ОбразовательнаяПрограмма"]
        when "подготовка бакалавров"   then ".62"
        when "подготовка магистров"    then ".68"
        when "подготовка специалистов" then ".65"
      end
      title = plan.at_css("Документ>План>Титул")
      speciality_code = title["ПоследнийШифр"] + suffix
      speciality = Speciality.find_by_code(speciality_code)
      unless speciality
         return nil, [], ["Не найдено специальности #{speciality_code}!"]
      end
      if allowed_specialities and not allowed_specialities.include? speciality
        return speciality, [], ["Вы не можете загружать план для специальности #{speciality.code} «#{speciality.name}»!"]
      end
      plan.css("Документ>План>СтрокиПлана>Строка").each do |row|
        discipline = Discipline.find_by_name(row["Дис"])
        discipline = Discipline.find_by_short_name(row["Дис"]) unless discipline
        if discipline
          result = {:discipline => discipline, :semesters => []}
          row.css("Сем").each do |sem|
            semnum = sem["Ном"].to_i
            semester = (semnum % 2 != 0) ? 1 : 2
            course = (semnum + (semnum % 2)) / 2
            plan = TeachingPlan.find_or_initialize_by_speciality_id_and_discipline_id_and_course_and_semester(
              speciality.id, discipline.id, course, semester
            )
            plan.lections = sem["Лек"]
            plan.practics = sem["Пр"]
            plan.lab_works = sem["Лаб"]
            plan.exam = (sem["Экз"] and not sem["Зач"]) ? true : false
            if plan.save
              result[:semesters] << plan
            else
              errors << "Не удалось сохранить строку плана за #{semester} семестр #{course} курса по предмету «#{discipline.name}»"
            end
          end
          results << result
        else
          errors << "Дисциплина «#{row["Дис"]}» не существует в системе"
        end
      end
    end
    return speciality, results, errors
  end

end
