# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :lesson_type do
    sequence(:name) { |i| "Lesson type #{i}" }
  end

end
