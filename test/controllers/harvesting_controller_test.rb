require 'test_helper'

class HarvestingControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get select" do
    get :select
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
