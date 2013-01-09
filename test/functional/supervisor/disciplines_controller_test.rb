# -*- encoding : utf-8 -*-
require 'test_helper'

class Supervisor::DisciplinesControllerTest < ActionController::TestCase
  setup do
    @supervisor_discipline = supervisor_disciplines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supervisor_disciplines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supervisor_discipline" do
    assert_difference('Supervisor::Discipline.count') do
      post :create, :supervisor_discipline => @supervisor_discipline.attributes
    end

    assert_redirected_to supervisor_discipline_path(assigns(:supervisor_discipline))
  end

  test "should show supervisor_discipline" do
    get :show, :id => @supervisor_discipline
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supervisor_discipline
    assert_response :success
  end

  test "should update supervisor_discipline" do
    put :update, :id => @supervisor_discipline, :supervisor_discipline => @supervisor_discipline.attributes
    assert_redirected_to supervisor_discipline_path(assigns(:supervisor_discipline))
  end

  test "should destroy supervisor_discipline" do
    assert_difference('Supervisor::Discipline.count', -1) do
      delete :destroy, :id => @supervisor_discipline
    end

    assert_redirected_to supervisor_disciplines_path
  end
end
