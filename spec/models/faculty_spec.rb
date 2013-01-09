# -*- encoding : utf-8 -*-
require "spec_helper"

describe Faculty do

  it "is invalid without name" do
    faculty = build(:faculty, :name => nil)
    faculty.should_not be_valid
  end

  it "name is unique" do
    faculty_1 = create(:faculty)
    faculty_2 = build(:faculty, :name => faculty_1.name)
    faculty_2.should_not be_valid
  end

  it "is invalid without full name" do
    faculty = build(:faculty, :full_name => nil)
    faculty.should_not be_valid
  end

  it "full name is unique" do
    faculty_1 = create(:faculty)
    faculty_2 = build(:faculty, :full_name => faculty_1.full_name)
    faculty_2.should_not be_valid
  end

end
