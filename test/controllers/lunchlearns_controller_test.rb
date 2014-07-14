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


  test "should not get calendar if user not logged in" do
    get :calendar
    assert_redirected_to :login
  end

  test "should be able to get new event page if admin" do
    get :new, {id: @lunchone.id}, {current_user_id: @admin.id}
    assert_response :success
  end

  test "should be able to get show view if admin" do
    get :show, {id: @lunchone.id}, {current_user_id: @admin.id}
    assert_response :success
  end

  test "should be able to get show view if not admin" do
    get :show, {id: @lunchone.id}, {current_user_id: @employeetwo.id}
    assert_response :success
  end

  test "should not be able to edit if user not logged in" do
    get :edit, {id: @lunchone.id}
    assert_redirected_to :login
  end

  test "should be able to edit if admin" do
    get :edit, {id: @lunchone.id}, {current_user_id: @admin.id}
    assert_response :success
  end
#views
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

  test "if no attendees, no users registered should display" do
    get :show, {id: @lunchtwo.id}, {current_user_id: @admin.id}
    assert_select 'h5', 'No users registered'
  end

  test "next LunchLearn should be displayed in the jumbotron" do
    get :calendar,{id: @lunchtwo.id}, {current_user_id: @admin.id} 
    assert_select 'h5', /Java.*/  
  end

  test "host information should be in the jumbotron" do
    get :calendar,{id: @lunchone.id}, {current_user_id: @admin.id}
    assert_select 'h5' do
      assert_select 'small',  /.*Hosted by  + @lunchone.lunch_hosts.collect { |w| w.display_name }.join(",")/
      end
  end

  test "lunclearn time and date should be in the jumbotron" do
    get :calendar,{id: @lunchtwo.id}, {current_user_id: @admin.id}
    assert_select 'strong', @lunchtwo.lunch_date.to_date.strftime("%B %d, %Y") + " at " + @lunchtwo.lunch_time.strftime("%I:%M %p")+ " to " + @lunchtwo.end_time.strftime("%I:%M %p")
  end
end
