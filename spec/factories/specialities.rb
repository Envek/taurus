# encoding: utf-8
FactoryGirl.define do

  factory :speciality do
    sequence(:name) { |i| "Speciality #{i}" }
    sequence(:code) { |i| "#{i%10}"*6 + ".62" }
    association :department
  end

end
