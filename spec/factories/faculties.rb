# encoding: utf-8
FactoryGirl.define do

  factory :faculty do
    sequence(:name) { |i| "F#{i}" }
    sequence(:full_name) { |i| "Faculty #{i}" }
  end

end
