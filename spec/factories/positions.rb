# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :position do
    sequence(:name) { |i| "Grand lecturer level #{i}" }
    sequence(:short_name) { |i| "Grlec l#{i}" }
  end

end
