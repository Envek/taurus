require "spec_helper"

describe Classroom do

  it "is invalid without name" do
    classroom = build(:classroom, :name => nil)
    classroom.should_not be_valid
  end

  it "is valid without building" do
    classroom = build(:classroom, :building => nil)
    classroom.should be_valid
  end

  it "name is unique for each building" do
    classroom_1 = create(:classroom)
    classroom_2 = build(:classroom, :name => classroom_1.name, :building => classroom_1.building)
    classroom_2.should_not be_valid
    classroom_3 = build(:classroom, :name => classroom_1.name)
    classroom_3.should be_valid
  end

  it "full name is identical to name if no building is present" do
    classroom = build(:classroom, :building => nil)
    classroom.full_name.should == classroom.name
  end

  it "full name includes building name in parentheses" do
    classroom = build(:classroom)
    classroom.full_name.should == "#{classroom.name} (#{classroom.building.name})"
  end

end
