require "spec_helper"

describe Building do

  it "is invalid without name" do
    building = build(:building, :name => nil)
    building.should_not be_valid
  end

  it "name is unique" do
    building_1 = create(:building)
    building_2 = build(:building, :name => building_1.name)
    building_2.should_not be_valid
  end

end
