# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :semester do
    sequence(:year) { |i| 2012+(i-1)/2 }
    sequence(:number) { |i| (i+1)%2+1 }
    full_time true
    open true
    published true
    start { Date.new(year, (number==1)?9:2, 1) }
    self.end { Date.new(year+1, (number==1)?1:6, 30) }
  end

end
