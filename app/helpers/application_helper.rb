# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(title_text)
    content_for(:title) { title_text }
  end

  def week_number (date=Date.today)
    semester_start_year = date.month < 9 ? date.year-1 : date.year
    semester_start = Date.strptime("#{semester_start_year}-09-01")
    startweek_no = semester_start.cwday.in?([6,7]) ? semester_start.cweek+1 : semester_start.cweek
    current_week = date.cweek + (date.year > semester_start_year ? 52 : 0)
    return 1 + ((current_week - startweek_no) % 2)
  end

  def pairs_split_by_time(pairs)
    return [[]] if pairs.nil? or pairs.empty?
    # Step 1. Find dates — groups separators
    activation_dates = pairs.map{|p| p[0].active_at}.uniq.sort
    separators = [activation_dates.min]
    until activation_dates.empty?
      sep = pairs.select{|p| p[0].active_at == activation_dates.min}.max_by{|p| p[0].expired_at}[0].expired_at
      separators << sep
      activation_dates = activation_dates.find_all { |d| d > sep }
    end
    # Step 2. Assign pairs to their groups
    groups = []
    separators.each do |date|
      group = pairs.find_all {|p| p[0].expired_at <= date}
      pairs = pairs - group
      group += pairs.find_all {|p| p[0].active_at < date}
      groups << group if group.any?
    end
    return groups
  end

  def markdown(text)
    MarkdownHandler.parser.render(text).html_safe
  end

  def departments_change_grouped_options_for_select(accessible_departments=Department.all)
    faculties = Faculty.joins(:departments).reorder('departments.gosinsp_code').includes(:departments)
    groups = faculties.map do |f|
      depts = f.departments & accessible_departments
      if depts.any?
        [f.name, depts.map{|d| [d.name, d.id] }]
      else
        nil
      end
    end.compact
    grouped_options_for_select(groups, current_department.id)
  end

end
