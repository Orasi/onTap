require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @lunchlearn = FactoryGirl.create(:lunchlearnstyle, :restricted) 
    @user = FactoryGirl.create(:normal_user)
    @admin=FactoryGirl.create(:admin_user)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end

  test "Admin should be added to attendees if event is restricted" do 
    get :change, {id: @lunchlearn.id}, {current_user_id: @admin.id}
    assert_not_nil flash[:success]
  end

  test "Base user should generate request when asking to attend a restricted event" do
    get :change, {id: @lunchlearn.id}, {current_user_id: @user.id}
    assert_not_nil flash[:success]
    assert_match "A request has been sent to attend the event: ", flash[:success]
  end

  test "Base user should destroy request if cancel request was selected" do
    get :change, {id: @lunchlearn.id}, {current_user_id: @user.id}
    get :change, {id: @lunchlearn.id}, {current_user_id: @user.id}
    assert_not_nil flash[:success]
    assert_match "Cancelled request to attend: ", flash[:success]
  end


end
