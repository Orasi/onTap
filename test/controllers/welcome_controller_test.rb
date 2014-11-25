require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
  end

  test 'should get login' do
    get :login
    assert_response :success
  end

  test 'Should be redirected to calendar if already logged in' do
    get :login, {}, current_user_id: @user.id
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

  test 'user should validate if doesnt exists' do
skip
    params = {
      login: {
        username: 'some.guy',
        password: '1234'
      }
    }
    post :validate, params
    assert_redirected_to :calendar
  end


#No longer valid with ADFS
=begin  test 'user should not validate without password' do
     params = {
       login: {
         username: 'some.guy'
       }
     }
     post :validate, params
     assert_redirected_to :login
     assert_not_nil flash[:error]
   end
=end

  test 'user should be able to logout' do
    skip
    get :logout, {}, current_user_id: @user.id
    assert_redirected_to :login
    assert_not_nil flash[:error]
    assert_equal flash[:error], 'Logged Out'
  end
end
