# -*- encoding : utf-8 -*-
require "spec_helper"

describe Speciality do

  it "is invalid without name" do
    speciality = build(:speciality, :name => nil)
    speciality.should_not be_valid
  end

  it "name is not unique" do
    speciality_1 = create(:speciality)
    speciality_2 = build(:speciality, :name => speciality_1.name)
    speciality_2.should be_valid
  end

  it "is invalid without code" do
    speciality = build(:speciality, :code => nil)
    speciality.should_not be_valid
  end

  it "code is unique" do
    speciality_1 = create(:speciality)
    speciality_2 = build(:speciality, :code => speciality_1.code)
    speciality_2.should_not be_valid
  end

  it "is invalid without department" do
    speciality = build(:speciality, :department_id => nil)
    speciality.should_not be_valid
    speciality = create(:speciality)
    speciality.department.should be_kind_of(Department)
  end

end
