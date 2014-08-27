require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
  end

  test 'should get login' do
    get :login
    assert_response :success
  end

  test 'Should be redirected to calendar if already logged in' do
    get :login, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'user should validate if already exists' do
    params = {
               login: {
                 username: @user.username,
                 password: '1234'
               }
              }
    post :validate, params
    assert_redirected_to :calendar
  end

  
end
