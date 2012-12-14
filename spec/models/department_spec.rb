require "spec_helper"

describe Department do

  it "is invalid without name" do
    department = build(:department, :name => nil)
    department.should_not be_valid
  end

  it "name is unique" do
    department_1 = create(:department)
    department_2 = build(:department, :name => department_1.name)
    department_2.should_not be_valid
  end

  it "is invalid without short name" do
    department = build(:department, :short_name => nil)
    department.should_not be_valid
  end

  it "short name is unique" do
    department_1 = create(:department)
    department_2 = build(:department, :short_name => department_1.short_name)
    department_2.should_not be_valid
  end

  it "is invalid without faculty" do
    department = build(:department, :faculty_id => nil)
    department.should_not be_valid
    department = create(:department)
    department.faculty.should be_kind_of(Faculty)
  end

  it "is valid without gosinsp code" do
    department = build(:department, :gosinsp_code => nil)
    department.should be_valid
  end

  it "gosinsp code is unique" do
    department_1 = create(:department)
    department_2 = build(:department, :gosinsp_code => department_1.gosinsp_code)
    department_2.should_not be_valid
  end

  it "gosinsp code is a positive integer number" do
    department_1 = build(:department, :gosinsp_code => "Whee")
    department_1.should_not be_valid
    department_2 = build(:department, :gosinsp_code => 0.5)
    department_2.should_not be_valid
    department_3 = build(:department, :gosinsp_code => -5)
    department_3.should_not be_valid
    department_4 = build(:department, :gosinsp_code => 0)
    department_4.should_not be_valid
    department_5 = build(:department, :gosinsp_code => 123)
    department_5.should be_valid
  end

end
