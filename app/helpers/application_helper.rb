# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def week_number (date=Date.today)
    semester_start_year = date.month < 9 ? date.year-1 : date.year
    semester_start = Date.strptime("#{semester_start_year}-09-01")
    startweek_no = semester_start.cwday == 7 ? semester_start.cweek+1 : semester_start.cweek
    current_week = date.cweek + (date.year > semester_start_year ? 52 : 0)
    return 1 + ((current_week - startweek_no) % 2)
  end

  def pairs_by_timeslot(pairs, day, pair)
    pairs.select {|p| p[0].pair_number == pair && p[0].day_of_the_week == day}
  end
  
  def pairs_split_by_time(pairs)
    return [[]] if pairs.empty?
    # Step 1. Find dates — groups separators
    activation_dates = pairs.map{|p| p[0].active_at}.uniq.sort
    separators = [activation_dates.min]
    activation_dates = activation_dates - separators
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
    groups += [pairs]
    return groups
  end

end
