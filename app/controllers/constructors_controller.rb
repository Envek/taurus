class ConstructorsController < ApplicationController
  cattr_reader :days, :times, :weeks, :templates
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

  def new

  end
  
  def add_grid
    
  end

  def show
    
  end
end