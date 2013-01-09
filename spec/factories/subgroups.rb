# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :subgroup do
    association :pair
    association :jet
    sequence(:number) {|i| [0,2,3][i%3] }
  end

end
