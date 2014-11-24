require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
<<<<<<< HEAD
  def setup
    @user = FactoryGirl.create(:normal_user)
    @user2 = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
    @profile = FactoryGirl.create(:profile)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end


  test 'User should be able to view edit page of their own profile' do
    @profile.update_attributes(user_id: @user.id)
    get :edit, { id: @user.id }, current_user_id: @user.id
=======
  
  test "should get new" do
skip
    get :new
>>>>>>> 899b6033244c4bd2dbb5e7b385347d04edb42650
    assert_response :success
  end

  test 'User should not be able to view edit page of another users profile' do
    @profile.update_attributes(user_id: @user.id)
    get :edit, { id: @user.id }, current_user_id: @user2.id
    assert_redirected_to :calendar
  end

  test 'Admin should not be able to view edit page of another users profile' do
    @profile.update_attributes(user_id: @user.id)
    get :edit, { id: @user.id }, current_user_id: @admin.id
    assert_redirected_to :calendar
  end

  test 'User should be able to update their own profile' do
    @profile.update_attributes(user_id: @user.id)
    params = {
      profile: {
      food_pref: 'None',
      location: 'Other',
      notification_settings: false
      },
      id: @profile.id
    }
    post :update, params, current_user_id: @user.id
    assert_redirected_to :back
#    assert_not_nil flash[:error], flash[:success]
  end

  test 'User should not be able to update another users profile' do
    @profile.update_attributes(user_id: @user.id)
    params = {
      profile: {
      food_pref: 'None',
      location: 'Other',
      notification_settings: false
      },
      id: @profile.id
    }
    @profile2 = FactoryGirl.create(:profile)
    @profile2.update_attributes(user_id: @user2.id)
    post :update, params, current_user_id: @user2.id
    assert_redirected_to :calendar
    assert_not_nil flash[:error], flash[:success]
  end

  test 'Admin should not be able to update another users profile' do
    @profile.update_attributes(user_id: @user.id)
    params = {
      profile: {
      food_pref: 'None',
      location: 'Other',
      notification_settings: false
      },
      id: @profile.id
    }
    @profile2 = FactoryGirl.create(:profile)
    @profile2.update_attributes(user_id: @admin.id)
    post :update, params, current_user_id: @admin.id
    assert_redirected_to :calendar
    assert_not_nil flash[:error], flash[:success]
  end
end
