# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :teaching_place, :aliases => [:assistant_teaching_place] do
    association :lecturer
    association :department
    association :position
  end

end
