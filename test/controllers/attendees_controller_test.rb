require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase
  def setup
    @restricted_event = FactoryGirl.create(:lunchlearnstyle, :restricted)
    @past_restricted_event = FactoryGirl.create(:lunchlearnstyle, :restricted, :past)
    @lunchlearn = FactoryGirl.create(:lunchlearnstyle)
    @past_event = FactoryGirl.create(:lunchlearnstyle, :past)
    @user = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end

  test 'Admin should be added to attendees if event is restricted' do
    assert_not_nil @restricted_event
    assert_not_nil @admin
    get :change, { id: @restricted_event.id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_match /A request has been sent to attend/, flash[:success]
    assert_not_nil Attendee.where(user_id: @admin.id, event_id: @restricted_event.id)
  end

  test 'base user should not be able to attend restricted event' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert Attendee.where(user_id: @user.id, event_id: @restricted_event.id).blank?
  end

  test 'Base user should generate request when asking to attend a restricted event' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
  end

  test 'admin should generate request when asking to attend a restricted event' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
  end

  test 'Base user should destroy request if cancel request was selected' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
    flash.delete(:success)
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /Cancelled request to attend/, flash[:error]
    assert Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
  end

  test 'admin should destroy request if cancel request was selected' do
    get :change, { id: @restricted_event.id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @admin.id, event_id: @restricted_event.id).blank?
    flash.delete(:success)
    get :change, { id: @restricted_event.id }, current_user_id: @admin.id
    assert_not_nil flash[:error]
    assert_match /Cancelled request to attend/, flash[:error]
    assert Request.where(user_id: @admin.id, event_id: @restricted_event.id).blank?
  end

  test 'user should be able to attend event' do
    get :change, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /now attending the event/, flash[:success]
    assert_not Attendee.where(user_id: @user.id, event_id: @lunchlearn.id).blank?
  end

  test 'admin should be able to attend event' do
    get :change, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_match /now attending the event/, flash[:success]
    assert_not Attendee.where(user_id: @admin.id, event_id: @lunchlearn.id).blank?
  end

  test 'host should not be able to attend event' do
    skip
    host = @lunchlearn.hosts.sample.user
    get :change, { id: @lunchlearn.id }, current_user_id: host.id
    assert_not_nil flash[:error]
    assert_match /now attending the event/, flash[:error]
    assert_not Attendee.where(user_id: host.id, event_id: @lunchlearn.id).blank?
  end

  test 'user should destroy attendance when not attending' do
    get :change, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /now attending the event/, flash[:success]
    assert_not Attendee.where(user_id: @user.id, event_id: @lunchlearn.id).blank?
    flash.delete(:success)
    get :change, { id: @lunchlearn.id }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_match /no longer attending the event/, flash.inspect
    assert Attendee.where(user_id: @user.id, event_id: @lunchlearn.id).blank?
  end

  test 'admin should destroy attendance when not attending' do
    get :change, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_match /now attending the event/, flash[:success]
    assert_not Attendee.where(user_id: @admin.id, event_id: @lunchlearn.id).blank?
    get :change, { id: @lunchlearn.id }, current_user_id: @admin.id
    assert_not_nil flash[:error]
    assert_match /no longer attending the event/, flash[:error]
    assert Attendee.where(user_id: @admin.id, event_id: @lunchlearn.id).blank?
  end

  test 'admin should be able to approve requeset' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
    get :approve_attend, { id: Request.find_by(user_id: @user.id, event_id: @restricted_event.id).id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_equal flash[:success], 'John Smith is now attending the event: some title!'
  end

  test 'admin should be not able to approve past event' do
    get :change, { id: @past_restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @past_restricted_event.id).blank?
    get :approve_attend, { id: Request.find_by(user_id: @user.id, event_id: @past_restricted_event.id).id }, current_user_id: @admin.id
    assert_not_nil flash[:error]
    assert_equal flash[:error], 'some title is in the archive.'
  end

  test 'admin should be able to reject request' do
    get :change, { id: @restricted_event.id }, current_user_id: @user.id
    assert_not_nil flash[:success]
    assert_match /request has been sent/, flash[:success]
    assert_not Request.where(user_id: @user.id, event_id: @restricted_event.id).blank?
    get :reject_attend, { id: Request.find_by(user_id: @user.id, event_id: @restricted_event.id).id }, current_user_id: @admin.id
    assert_not_nil flash[:success]
    assert_equal flash[:success], 'John Smith has been rejected from attending event: some title!'
  end

  test 'user should not be able to attend past event' do
    get :change, { id: @past_event }, current_user_id: @user.id
    assert_not_nil flash[:error]
    assert_equal flash[:error], 'some title is in the archive.'
  end

  # TEST FOR MANAGER/ADMIN APPROVAL/REJECTION
end
