class ConstructorsController < ApplicationController
  cattr_reader :days, :times, :weeks
  @@days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота'
  ]
  @@times = [
    '08:15 - 09:45',
    '09:55 - 11:25',
    '11:35 - 13:05',
    '14:00 - 15:30',
    '15:40 - 17:10',
    '17:20 - 18:50',
    '19:00 - 20:30'
  ]
  @@weeks = [
    '1 неделя',
    '2 неделя'
  ]
  def after_initialize
    @days = self.class.days
    @times = self.class.times
    @weeks = self.class.weeks
  end

  def add_grid
    @grid = Classroom.first(:conditions => {:id => params[:pairs][:classroom]})
    @pairs = @grid.pairs
  end

  def show
    
  end

  def show_form
    
  end

  def hide_form

  end


end