# -*- encoding : utf-8 -*-
require 'test_helper'

class Supervisor::JetsControllerTest < ActionController::TestCase
  setup do
    @supervisor_jet = supervisor_jets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supervisor_jets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supervisor_jet" do
    assert_difference('Supervisor::Jet.count') do
      post :create, :supervisor_jet => @supervisor_jet.attributes
    end

    assert_redirected_to supervisor_jet_path(assigns(:supervisor_jet))
  end

  test "should show supervisor_jet" do
    get :show, :id => @supervisor_jet
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supervisor_jet
    assert_response :success
  end

  test "should update supervisor_jet" do
    put :update, :id => @supervisor_jet, :supervisor_jet => @supervisor_jet.attributes
    assert_redirected_to supervisor_jet_path(assigns(:supervisor_jet))
  end

  test "should destroy supervisor_jet" do
    assert_difference('Supervisor::Jet.count', -1) do
      delete :destroy, :id => @supervisor_jet
    end

    assert_redirected_to supervisor_jets_path
  end
end
