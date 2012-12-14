# encoding: utf-8
FactoryGirl.define do

  factory :building do
    sequence(:name) { |i| "Building #{i}" }
  end

end
