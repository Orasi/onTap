require 'test_helper'

class LunchAndLearnControllerTest < ActionController::TestCase
  test "should get calendar" do
    get :calendar
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
