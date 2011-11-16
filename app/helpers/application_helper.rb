# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def week_number (date=Date.today)
    semester_start_year = date.month < 9 ? date.year-1 : date.year
    semester_start = Date.strptime("#{semester_start_year}-09-01")
    startweek_no = semester_start.cwday == 7 ? semester_start.cweek+1 : semester_start.cweek
    current_week = date.cweek + (date.year > semester_start_year ? 52 : 0)
    return 1 + ((current_week - startweek_no) % 2)
  end

end
