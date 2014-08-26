require 'test_helper'

class ArchiveControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
  end

  test 'should not get index if user not logged in' do
    get :index
    assert_redirected_to :login
  end

  test 'should be able to get index as base user' do
    get :index, current_user_id: @user.id
    assert_redirected_to :login
  end

  test 'should be able to get index as base admin' do
    get :index, current_user_id: @admin.id
    assert_redirected_to :login
  end
end
