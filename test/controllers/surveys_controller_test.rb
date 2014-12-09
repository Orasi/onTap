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

  test 'User should have a survey notification for event to take a survey' do
    @surveynotification.update_attributes(user_id: @user.id, event_id: @futureevent.id)
    get :new, { event_id: @futureevent.id }, current_user_id: @user.id
    assert_response :success
  end

  test 'User should not be able to take a survey without a notification' do
    get :new, { event_id: @futureevent.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /No survey for you to take for this event/, flash[:error]
  end

  test 'Base user should not be able to view surveys index' do
    get :index, { id: @futureevent.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /Must be a host or admin to view these surveys/, flash[:error]
  end

  test 'Admin should be able to view surveys index' do
    get :index, { id: @futureevent.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'Host should be able to view surveys index of event' do
    @futureevent.hosts.create(user_id: @user.id)
    get :index, { id: @futureevent.id }, current_user_id: @user.id
    assert_response :success
  end

  test 'Survey should be created' do
    notification = FactoryGirl.create(:notification, :surveynotification)
    params = {
              survey:
                {
                    went_well: 1,
                    improved: 1,
                    host_knowledge: 1,
                    host_presentation: 1,
                    effect: 1,
                    extra: 1,
                    event_id: notification.event_id
                }
              }
    post :create, params, current_user_id: notification.user_id
    assert_not_nil flash[:success]
    assert_match /Event survey was submitted/, flash[:success]
  end

  test 'survey should not be created if event_id is blank' do
    notification = FactoryGirl.create(:notification, :surveynotification)
    params = {
        survey:
            {
                went_well: 1,
                improved: 1,
                host_knowledge: 1,
                host_presentation: 1,
                effect: 1,
                extra: 1,
                event_id: nil
            }
    }
    post :create, params, current_user_id: notification.user_id
    assert_not_nil flash[:error]
    assert_match /Survey  was not created/, flash[:error]
  end
end
