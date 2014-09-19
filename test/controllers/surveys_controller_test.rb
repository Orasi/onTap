require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
    @surveynotification = FactoryGirl.create(:notification, :new, :surveynotification)
    @survey = FactoryGirl.create(:survey)
    @futureevent = FactoryGirl.create(:lunchlearnstyle, :future)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end

  test "User should have a survey notification for event to take a survey" do
    @surveynotification.update_attributes(:user_id => @user.id, :event_id => @futureevent.id)
    get :new, { event_id: @futureevent.id }, current_user_id: @user.id
    assert_response :success
  end

  test "User should not be able to take a survey without a notification" do
    get :new, { event_id: @futureevent.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /No survey for you to take for this event/, flash[:error]
  end

  test "Base user should not be able to view surveys index" do
    get :index, { id: @futureevent.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /Must be a host or admin to view these surveys/, flash[:error]
  end

  test "Admin should be able to view surveys index" do
    get :index, { id: @futureevent.id }, current_user_id: @admin.id
    assert_response :success
  end

  test "Host should be able to view surveys index of event" do
    @futureevent.hosts.create(user_id: @user.id)
    get :index, { id: @futureevent.id }, current_user_id: @user.id
    assert_response :success
  end
end
