require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    @admin = FactoryGirl.create(:admin_user)
    @suggestion = FactoryGirl.create(:suggestion)
  end

  test 'should not get index if user not logged in' do
    get :index
    assert_redirected_to :login
  end

  test 'should not be able to get new page if not logged in' do
    get :new, id: @user.id
    assert_redirected_to :login
  end

  test 'should be able to get new page if any user' do
    get :new, {}, current_user_id: @user.id
    assert_response :success
  end

  test 'should be able to get show view if admin' do
    get :show, { id: @suggestion.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should not be able to get show view if not admin' do
    get :show, { id: @suggestion.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to edit if user not logged in' do
    get :edit, id: @suggestion.id
    assert_redirected_to :login
  end

  test 'should be able to edit if admin' do
    get :edit, { id: @suggestion.id }, current_user_id: @admin.id
    assert_response :success
  end

  # Change this functionality?
  test 'should not be able to edit if suggestor' do
    get :edit, { id: @suggestion.id }, current_user_id: @suggestion.user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to edit if not admin' do
    get :edit, { id: @suggestion.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should be able to commit edits if admin' do
    post :edit, { id: @suggestion.id }, current_user_id: @admin.id
    assert_response :success
  end

  test 'should not be able to commit edit if not admin' do
    post :edit, { id: @suggestion.id }, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to commit edit if not logged in' do
    post :edit, id: @suggestion.id
    assert_redirected_to :login
  end
end
