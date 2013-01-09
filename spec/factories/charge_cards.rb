# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :charge_card do
    association :semester
    association :teaching_place
    association :assistant_teaching_place
    association :lesson_type
    association :discipline
    weeks_quantity 9
    hours_per_week 2
  end

end
