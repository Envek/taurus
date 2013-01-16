require "spec_helper"

describe DeptHead::ClassroomsController do
  describe "routing" do

    it "routes to #index" do
      get("/dept_head/classrooms").should route_to("dept_head/classrooms#index")
    end

    it "routes to #new" do
      get("/dept_head/classrooms/new").should route_to("dept_head/classrooms#new")
    end

    it "routes to #show" do
      get("/dept_head/classrooms/1").should route_to("dept_head/classrooms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dept_head/classrooms/1/edit").should route_to("dept_head/classrooms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dept_head/classrooms").should route_to("dept_head/classrooms#create")
    end

    it "routes to #update" do
      put("/dept_head/classrooms/1").should route_to("dept_head/classrooms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dept_head/classrooms/1").should route_to("dept_head/classrooms#destroy", :id => "1")
    end

  end
end
