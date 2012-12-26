# encoding: utf-8
FactoryGirl.define do

  factory :jet do
    association :charge_card
    association :group
    sequence(:subgroups_quantity) {|i| [0,2,3][i%3] }
  end

end
