require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    @usertwo = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
    @newnotification = FactoryGirl.create(:notification, :new, :attendancenotification)
    @acceptednotification = FactoryGirl.create(:notification, :approved, :attendancenotification)
    @rejectednotification = FactoryGirl.create(:notification, :rejected, :attendancenotification)
    @surveynotification = FactoryGirl.create(:notification, :new, :surveynotification)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end


  test 'User should be able to delete accepted attendance request' do
    @acceptednotification.update_attribute(:user_id, @user.id)
    eventid=@acceptednotification.event_id
    assert_not Notification.where(user_id: @user.id, event_id: eventid, status: "approved").blank?
    delete :destroy, { id: @acceptednotification.id }, current_user_id: @user.id
    assert Notification.where(user_id: @user.id, event_id: eventid, status: "approved").blank?
  end

  test 'User should be able to delete rejected attendance request' do
    @rejectednotification.update_attribute(:user_id, @user.id)
    eventid=@rejectednotification.event_id
    assert_not Notification.where(user_id: @user.id, event_id: eventid, status: "rejected").blank?
    delete :destroy, { id: @rejectednotification.id }, current_user_id: @user.id
    assert Notification.where(user_id: @user.id, event_id: eventid, status: "rejected").blank?
  end

  test 'User should not be able to delete another users notifications' do
    @acceptednotification.update_attribute(:user_id, @user.id)
    eventid=@acceptednotification.event_id
    assert_not Notification.where(user_id: @user.id, event_id: eventid, status: "approved").blank?
    delete :destroy, { id: @acceptednotification.id }, current_user_id: @usertwo.id
    assert_not_nil flash[:error]
    assert_equal flash[:error], 'Must be notification owner or admin to remove notification'  
  end

  test 'Admin should be able to delete another users request' do
    @acceptednotification.update_attribute(:user_id, @user.id)
    eventid=@acceptednotification.event_id
    assert_not Notification.where(user_id: @user.id, event_id: eventid, status: "approved").blank?
    delete :destroy, { id: @acceptednotification.id }, current_user_id: @admin.id
    assert Notification.where(user_id: @user.id, event_id: eventid, status: "approved").blank?
  end

  test 'Survey notification should not be removable if survey not complete' do
  end

  test 'Survey notification should be removable if survey is complete' do
  end

#  test 'Users should see survey notifications' do

 # end
end
