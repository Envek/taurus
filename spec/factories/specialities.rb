# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :speciality do
    sequence(:name) { |i| "Speciality #{i}" }
    sequence(:code) { |i| ("%06d" % i) + ".62" }
    association :department
  end

end
