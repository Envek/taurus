# -*- encoding : utf-8 -*-
Building.create([
  {:name => 'главный'},
  {:name => '5'},
  {:name => '6'},
  {:name => '7'},
  {:name => '8'}
])

LessonType.create([
  {:name => 'лекция'},
  {:name => 'практика'},
  {:name => 'лабораторная работа'}
])

fmi = Faculty.create({
  :name => 'ФМИ', :full_name => 'Факультет математики и информатики'
})

Department.create({
  :short_name => "ИиУС", :name => "Информационных и управляющих систем", :faculty => fmi
})

Position.create([
  {:name => 'ассистент', :short_name => 'асс.'},
  {:name => 'старший преподаватель', :short_name => 'ст.п.'},
  {:name => 'доцент', :short_name => 'доц.'},
  {:name => 'профессор', :short_name => 'проф.'}
])

Semester.create({
  :year => Date.today.year - (Date.today.month < 8 ? 1 : 0),
  :number => Date.today.month < 8 ? 2 : 1,
  :start => Date.new( Date.today.year, (Date.today.month < 8 ? 1 : 9), 1),
  :end => Date.new( Date.today.year, (Date.today.month < 8 ? 7 : 12), 31),
  :full_time => true, :published => true,
})

admin = User.new({
    :login => "admin", :name => "Администратор системы",
    :email => "admin@taurus.local", :password => "12345678", :password_confirmation => "12345678"
  })
admin.admin = true;
admin.save!
