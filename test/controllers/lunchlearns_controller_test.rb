require 'test_helper'

class LunchlearnsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @lunchone=lunchlearns(:lunchone)
    @lunchtwo=lunchlearns(:lunchtwo)
    @employee=users(:employee)
    @employeetwo=users(:employeetwo)
    @host=users(:host)
    @admin=users(:admin)
  end

  test "should see lunchlearn info if attendee" do
    get :show, {id: @lunchone.id}, {current_user_id: @employee.id}
    assert_select 'h5', 'The following users have registered to attend'
  end

  test "should not see lunchlearn info if not attendee" do
    get :show, {id: @lunchone.id}, {current_user_id: @employeetwo.id}
    assert_select 'h5', false, 'Information is hidden from the user'
  end

  test "should see lunchlearn info if host" do
    get :show, {id: @lunchone.id}, {current_user_id: @host.id}
    assert_select 'h5', 'The following users have registered to attend'
  end

  test "should see lunchlearn info if admin" do
    get :show, {id: @lunchone.id}, {current_user_id: @admin.id}
    assert_select 'h5', 'The following users have registered to attend'
  end

  test "host should be listed on show page" do
    get :show, {id: @lunchone.id}, {current_user_id: @employee.id}
    assert_select 'h1', /.*hosted by Lewis Gordon/
  end

  test "if no attendees, no users registered should display" do
    get :show, {id: @lunchtwo.id}, {current_user_id: @admin.id}
    assert_select 'h5', 'No users registered'
  end
end
