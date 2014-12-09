require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
    @admin = FactoryGirl.create(:admin_user)
    assert @admin
  end

  test 'can create new profile if no profile' do
    profile = Profile.new_user_profile @user.id
    assert profile
  end

end
