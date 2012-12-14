require "spec_helper"

describe Group do

  it "is invalid without name" do
    group = build(:group, :name => nil)
    group.should_not be_valid
  end

  it "name is unique" do
    group_1 = create(:group)
    group_2 = build(:group, :name => group_1.name)
    group_2.should be_valid
  end

  it "is invalid without forming year" do
    group = build(:group, :forming_year => nil)
    group.should_not be_valid
  end

  it "is invalid without speciality" do
    group = build(:group, :speciality_id => nil)
    group.should_not be_valid
    group = create(:group)
    group.speciality.should be_kind_of(Speciality)
  end

  it "is valid without population" do
    group = build(:group, :population => nil)
    group.should be_valid
  end

  it "population is a positive integer number" do
    group_1 = build(:group, :population => "Whee")
    group_1.should_not be_valid
    group_2 = build(:group, :population => 0.5)
    group_2.should_not be_valid
    group_3 = build(:group, :population => -5)
    group_3.should_not be_valid
    group_4 = build(:group, :population => 0)
    group_4.should_not be_valid
    group_5 = build(:group, :population => 15)
    group_5.should be_valid
  end

end
