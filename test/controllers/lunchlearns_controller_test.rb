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
    assert_select 'h4', 'The following users have registered to attend'
  end

  test "should not see lunchlearn info if not attendee" do
    get :show, {id: @lunchone.id}, {current_user_id: @employeetwo.id}
    assert_select 'h5', false, 'Information is hidden from the user'
  end

  test "should see lunchlearn info if host" do
    get :show, {id: @lunchone.id}, {current_user_id: @host.id}
    assert_select 'h4', 'The following users have registered to attend'
  end

  test "should see lunchlearn info if admin" do
    get :show, {id: @lunchone.id}, {current_user_id: @admin.id}
    assert_select 'h4', 'The following users have registered to attend'
  end

  test "host should be listed on show page" do
    get :show, {id: @lunchone.id}, {current_user_id: @employee.id}
    assert_select 'jumbo-hosts-name', /.*Lewis Gordon/
  end

  test "if no attendees, no users registered should display" do
    get :show, {id: @lunchtwo.id}, {current_user_id: @admin.id}
    assert_select 'h5', 'No users registered'
  end

  test "next LunchLearn should be displayed in the jumbotron" do
    get :calendar,{id: @lunchtwo.id}, {current_user_id: @admin.id} 
    assert_select 'h5', /Ruby.*/  
  end

  test "host information should be in the jumbotron" do
    get :calendar,{id: @lunchone.id}, {current_user_id: @admin.id}
    assert_select 'h5', /.*Hosted by  + @lunchone.lunch_hosts.collect { |w| w.display_name }.join(",")/
  end

  test "lunclearn time and date should be in the jumbotron" do
    get :calendar,{id: @lunchone.id}, {current_user_id: @admin.id}
    assert_select 'p', @lunchone.lunch_date.to_date.strftime("%B %d, %Y") + " at " + @lunchone.lunch_time.to_formatted_s(:time)
  end
end
