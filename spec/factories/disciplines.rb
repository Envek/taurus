# encoding: utf-8
FactoryGirl.define do

  factory :discipline do
    sequence(:name) { |i| "Discipline #{i}" }
    sequence(:short_name) { |i| "Dcpl #{i}" }
    association :department
  end

end
