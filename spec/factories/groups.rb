# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :group do
    sequence(:name) { |i| "Group #{i}" }
    sequence(:forming_year) { |i| 2000+i%100 }
    sequence(:population) { |i| i }
    association :speciality
  end

end
