# encoding: utf-8
require "rspec"
require "spec_helper"

feature "Timetable display" do

  before(:all) do
    @semesters = [create(:semester), create(:semester)]
    @semesters << create(:semester, :published => false)
    @groups = ["257ом", "253ом", "253ос"].map {|name| create(:group, :name => name)}
    @charge_cards = @groups.map do |group|
      card = create(:charge_card, :semester => @semesters.first)
      card.teaching_place.lecturer.name = "Преподаватель #{group.name}"
      card.teaching_place.lecturer.save
      create(:jet, :group => group, :charge_card => card)
      card
    end
    @charge_cards << create(:charge_card, :semester => @semesters.second)
    create(:jet, :group => @groups.first, :charge_card => @charge_cards.last)
    @pairs = @charge_cards.map do |cc|
      pair = create(:pair, :charge_card => cc)
      create(:subgroup, :pair => pair, :jet => cc.jets.first)
      pair
    end
    @groups << create(:group) # One additional group
  end

  scenario "should display group list" do
    visit timetable_groups_path
    page.should have_selector("div.group", :count => 3)
  end

  scenario "should search fo groups without javascript" do
    visit timetable_groups_path
    fill_in "group_name_input", :with => "253"
    find("#group_name_input + button").click
    page.should have_selector("div.group", :count => 2)
  end

  scenario "should redirect to group timetable if search result is a single group" do
    visit timetable_groups_path
    fill_in "group_name_input", :with => "257"
    find("#group_name_input + button").click
    page.should have_selector("div.group_timetable")
  end

  scenario "should search for groups with javascript", :js => true do
    visit timetable_groups_path
    fill_in "group_name_input", :with => "257"
    page.should have_selector("div.group", :count => 1)
  end

  scenario "should display group timetable" do
    visit timetable_groups_path
    find("div.group:first-child a.link_to_timetable").click
    page.should have_selector("div.group_timetable")
    page.should have_selector("table.daycell")
  end

  scenario "should generate group timetable in Excel format" do
    visit timetable_group_path(@groups.first)
    find("a.excel_export").click
    page.response_headers["Content-Disposition"].should start_with("attachment")
    page.response_headers["Content-Disposition"].should include("filename")
    page.response_headers['Content-Type'].should == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  scenario "should display lecturer list" do
    visit timetable_lecturers_path
    page.should have_selector("div.lecturer", :count => 8)
  end

  scenario "should search fo lecturers without javascript" do
    visit timetable_lecturers_path
    fill_in "lecturer_name_input", :with => "Преподаватель 253"
    find("#lecturer_name_input + button").click
    page.should have_selector("div.lecturer", :count => 2)
  end

  scenario "should redirect to lecturer timetable if search result is a single lecturer" do
    visit timetable_lecturers_path
    fill_in "lecturer_name_input", :with => "Преподаватель 253ос"
    find("#lecturer_name_input + button").click
    page.should have_selector("div.lecturer_timetable")
  end

  scenario "should search for lecturers with javascript", :js => true do
    visit timetable_lecturers_path
    fill_in "lecturer_name_input", :with => "Преподаватель 253ос"
    page.should have_selector("div.lecturer", :count => 1)
  end

  scenario "should allow to set current semester and redirect back", :js => true do
    visit timetable_groups_path
    page.should have_selector("#semester_id > option", :count => 2)
    find("#semester_id option:not([selected])").select_option
    page.should have_selector("div.group", :count => 1)
    current_path.should == timetable_groups_path
    visit timetable_lecturers_path
    page.should have_selector("#semester_id > option", :count => 2)
    find("#semester_id option:not([selected])").select_option
    page.should have_selector("div.lecturer")
    current_path.should == timetable_lecturers_path
  end
end
