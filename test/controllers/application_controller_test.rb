class ApplicationControllerTest < ActionController::TestCase

  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
    @admin = FactoryGirl.create(:admin_user)
    assert @admin
  end

  test 'Admin should be able to view metrix page' do
    get :metrics, {}, current_user_id: @admin.id
    assert_response :success
  end

  test 'Base user should not be able to view metrix page' do
    get :metrics, {}, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not get index if user not logged in' do
    get :metrics
    assert_redirected_to :login
  end
end
