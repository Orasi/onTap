require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  def setup
    @user = FactoryGirl.create(:normal_user)
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "Should be redirected to calendar if already logged in" do
    get :login, {current_user_id: @user.id}
  end
end
