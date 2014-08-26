require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
  end

  test 'should not get notifications page if user not logged in' do
    get :notifications
    assert_redirected_to :login
  end

  # test "should get notifications page if user logged in" do
  #  get :notifications, {current_user_id: @admin.id}
  #  assert_response :success
  # end

  # Rest of these would be view tests, I can do these

  test 'Admin should see pending attendance requests' do
  end

  test 'Base users should not see pending attendance requests' do
  end

  test 'Base users should see their accepted request' do
  end

  test 'Base users should see their rejected request' do
  end
end
