require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  
  test "should get new" do
skip
    get :new
    assert_response :success
  end

end
