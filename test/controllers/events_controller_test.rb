require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  def setup
    @lunchlearn = FactoryGirl.create(:lunchlearnstyle)
    @user = FactoryGirl.create(:normal_user)
    # @event_with_hosts = FactoryGirl.create(:event_with_hosts)
    # @lunchtwo=lunchlearns(:lunchtwo)
    # @employee=users(:employee)
    # @employeetwo=users(:employeetwo)
    # @host=users(:host)
    @admin = FactoryGirl.create(:admin_user)
  end

  test 'should not get calendar if user not logged in' do
    get :calendar
    assert_redirected_to :login
  end

  test 'should be able to get new event page if admin' do
    get :new, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should not be able to get edit page if not logged in' do
    get :new, id: @lunchlearn.id
    assert_redirected_to :login
  end

  test 'should not be able to get edit page if not admin' do
    get :new, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to get to new page if not admin' do
    get :new, {}, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should be able to get to new page if admin' do
    get :new, {}, current_user_id: @admin.id
    assert_response :success
  end

  test 'should be able to get show view if admin' do
    get :show, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should be able to get show view if not admin' do
    get :show, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_response :success
  end

  test 'should not be able to edit if user not logged in' do
    get :edit, id: @lunchlearn.id
    assert_redirected_to :login
  end

  test 'should be able to edit if admin' do
    get :edit, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should be able to edit if host' do
    get :edit, { id: @lunchlearn.id }, current_user_id: @lunchlearn.hosts.first.user_id
    assert_response :success
  end

  test 'should not be able to edit if not host or admin' do
    get :edit, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should be able to commit edits if admin' do
    post :edit, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should be able to commit edits if host' do
    post :edit, { id: @lunchlearn.id }, current_user_id: @lunchlearn.hosts.first.user_id
    assert_response :success
  end

  test 'should not be able to commit post if not admin or event host' do
    post :edit, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to commit post if not logged in' do
    post :edit, id: @lunchlearn.id
    assert_redirected_to :login
  end

  # views
  test 'should see lunchlearn info if attendee' do
    get :show, { id: @lunchlearn.id }, current_user_id: @lunchlearn.attendees.sample.user_id
   	assert_select 'h4', 'The following users have registered to attend'
  end

  test 'should not see lunchlearn info if not attendee' do
    get :show, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_response :success
    assert_select 'h4', false, 'Information is hidden from the user'
  end

  test 'should see lunchlearn info if host' do
    get :show, { id: @lunchlearn.id }, current_user_id: @lunchlearn.hosts.sample.user_id
    assert_select 'h4', 'The following users have registered to attend'
  end

  test 'should see lunchlearn info if admin' do
    get :show, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_select 'h4', 'The following users have registered to attend'
  end

  test 'host should be listed on show page' do
    get :show, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_response :success
    assert_select '.h1', /#{@lunchlearn.title}/
  end

  # Need to create factory trait for event with no attendees
  # test "if no attendees, no users registered should display" do
  #   get :show, {id: @lunchlearn.id}, {current_user_id: @admin.id}
  #   assert_select 'h5', 'No users registered'
  # end

  #  test "next LunchLearn should be displayed in the jumbotron" do
  #    get :calendar,{id: @lunchtwo.id}, {current_user_id: @admin.id}
  #    assert_select 'h5', /Java.*/
  #  end

  #  test "host information should be in the jumbotron" do
  # get :calendar,{id: @lunchone.id}, {current_user_id: @admin.id}
  # assert_select 'h5' do
  #  assert_select 'small',  /.*Hosted by  + @lunchone.lunch_hosts.collect { |w| w.display_name }.join(",")/
  #  end
  #  end

  #  test "lunclearn time and date should be in the jumbotron" do
  # get :calendar,{id: @lunchtwo.id}, {current_user_id: @admin.id}
  # assert_select 'strong', @lunchtwo.lunch_date.to_date.strftime("%B %d, %Y") + " at " + @lunchtwo.lunch_time.strftime("%I:%M %p")+ " to " + @lunchtwo.end_time.strftime("%I:%M %p")
  #  end
end
