# -*- encoding : utf-8 -*-
require 'test_helper'

class Supervisor::ChargeCardsControllerTest < ActionController::TestCase
  setup do
    @supervisor_charge_card = supervisor_charge_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supervisor_charge_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supervisor_charge_card" do
    assert_difference('Supervisor::ChargeCard.count') do
      post :create, :supervisor_charge_card => @supervisor_charge_card.attributes
    end

    assert_redirected_to supervisor_charge_card_path(assigns(:supervisor_charge_card))
  end

  test "should show supervisor_charge_card" do
    get :show, :id => @supervisor_charge_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @supervisor_charge_card
    assert_response :success
  end

  test "should update supervisor_charge_card" do
    put :update, :id => @supervisor_charge_card, :supervisor_charge_card => @supervisor_charge_card.attributes
    assert_redirected_to supervisor_charge_card_path(assigns(:supervisor_charge_card))
  end

  test "should destroy supervisor_charge_card" do
    assert_difference('Supervisor::ChargeCard.count', -1) do
      delete :destroy, :id => @supervisor_charge_card
    end

    assert_redirected_to supervisor_charge_cards_path
  end
end
