# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :classroom do
    sequence(:name) { |i| i.to_s }
    association :building
    association :department
    capacity 25
    department_lock false
  end

end
