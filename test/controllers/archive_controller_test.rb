require 'test_helper'

class ArchiveControllerTest < ActionController::TestCase

  test "should not get index if user not logged in" do
    get :index
    assert_redirected_to :login
  end
end
