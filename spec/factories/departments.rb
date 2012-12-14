# encoding: utf-8
FactoryGirl.define do

  factory :department do
    sequence(:name) { |i| "Department #{i}" }
    sequence(:short_name) { |i| "Dept#{i}" }
    sequence(:gosinsp_code) { |i| i }
    association :faculty
  end

end
