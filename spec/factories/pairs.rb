# encoding: utf-8
FactoryGirl.define do

  factory :pair do
    association :charge_card
    association :classroom
    sequence(:day_of_the_week) { |i| (i-1)%6+1 }
    sequence(:pair_number) { |i| (i-1)%8+1 }
    sequence(:week) { |i| (i-1)%3 }
    active_at  { charge_card.semester.start }
    expired_at { charge_card.semester.end }
  end

end
