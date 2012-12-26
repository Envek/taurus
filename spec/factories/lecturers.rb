# encoding: utf-8
FactoryGirl.define do

  factory :lecturer do
    sequence(:name) { |i| "Lecturer #{i}" }
    whish ""
  end

end
