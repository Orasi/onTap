require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup 
    @user = FactoryGirl.create(:normal_user)
    @admin=FactoryGirl.create(:admin_user)
  end


  test "should not get notifications page if user not logged in" do
    get :user_notifications
    assert_redirected_to :login
  end

  test "should not get notifications page if user not logged in" do
    get :user_notifications, {current_user_id: @user.id}
    assert_response :success
  end

#Rest of these would be view tests, I can do these

  test "Admin should see pending attendance requests"
  end

  test "Base users should not see pending attendance requests"
  end

  test "Base users should see their accepted request"
  end

  test "Base users should see their rejected request"
  end
end

