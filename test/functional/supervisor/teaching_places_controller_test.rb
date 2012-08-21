require 'test_helper'

class Supervisor::TeachingPlacesControllerTest < ActionController::TestCase
  setup do
    @supervisor_teaching_place = supervisor_teaching_places(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supervisor_teaching_places)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supervisor_teaching_place" do
    assert_difference('Supervisor::TeachingPlace.count') do
      post :create, :supervisor_teaching_place => @supervisor_teaching_place.attributes
    end

    assert_redirected_to supervisor_teaching_place_path(assigns(:supervisor_teaching_place))
  end

  test "should show supervisor_teaching_place" do
    get :show, :id => @supervisor_teaching_place
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supervisor_teaching_place
    assert_response :success
  end

  test "should update supervisor_teaching_place" do
    put :update, :id => @supervisor_teaching_place, :supervisor_teaching_place => @supervisor_teaching_place.attributes
    assert_redirected_to supervisor_teaching_place_path(assigns(:supervisor_teaching_place))
  end

  test "should destroy supervisor_teaching_place" do
    assert_difference('Supervisor::TeachingPlace.count', -1) do
      delete :destroy, :id => @supervisor_teaching_place
    end

    assert_redirected_to supervisor_teaching_places_path
  end
end
