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

  test 'should be able to get index if admin' do
    get :index, {}, {current_user_id: @admin.id}
    assert_response :success
  end

  test 'should not be able to get new page if not logged in' do
    get :new
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

  test 'should not be able to create if not admin' do
    params = {
             suggestion: {
               suggestion_title: "some title",
               suggestion_description: "some description"
               }
            }
    post :create, params, current_user_id: @user.id
    assert_redirected_to :calendar
  end

  test 'should not be able to commit edit if not logged in' do
    post :create
    assert_redirected_to :login
  end

  test 'should be able to create if admin' do
    params = {
             suggestion: {
               suggestion_title: "some title",
               suggestion_description: "some description"
               }
            }
   post :create, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:success], flash[:error]
  end

  test 'should not be able to create without title' do
    params = {
             suggestion: {
               suggestion_description: "some description"
               }
            }
   post :create, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:error], flash[:success]
  end

  test 'should not be able to create without description' do
    params = {
             suggestion: {
               suggestion_title: "some title"
               }
            }
   post :create, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:error], flash[:success]
  end

  test 'should be able to update if admin' do
    params = {
             suggestion: {
               suggestion_title: "some title",
               suggestion_description: "some description"
               },
             id: @suggestion.id 
             }
   patch :update, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:success], flash[:error]
  end

  test 'should not be able to update if not admin' do
    params = {
             suggestion: {
               suggestion_title: "some title",
               suggestion_description: "some description"
               },
             id: @suggestion.id 
             }
   patch :update, params, {current_user_id: @user.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:error], flash[:success]
  end

  test 'should not be able to edit without description' do
    params = {
             suggestion: {
               suggestion_title: "some title",
               suggestion_description: ""
               },
             id: @suggestion.id 
             }
   patch :update, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:error], flash[:success]
  end  

  test 'should not be able to edit without title' do
    params = {
             suggestion: {
               suggestion_title: "",
               suggestion_description: "Some Description"
               },
             id: @suggestion.id 
             }
   patch :update, params, {current_user_id: @admin.id}
   assert_redirected_to :calendar
   assert_not_nil flash[:error], flash[:success]
  end  

  test 'should be able to delete if admin' do
    delete :destroy, {id: @suggestion.id}, {current_user_id: @admin.id}
    assert_not_nil flash[:error]
    assert_equal flash[:error], "Suggestion \"some suggestion title\" was deleted"
  end

  test 'should not be able to delete if not admin' do
    delete :destroy, {id: @suggestion.id}, {current_user_id: @user.id}
    assert_not_nil flash[:error]
    assert_equal flash[:error], "You do not have the required permissions to access this area"
  end
end
