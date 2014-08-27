require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
    @lunchlearn = FactoryGirl.create(:lunchlearnstyle)
    assert @lunchlearn
    @webinar = FactoryGirl.create(:webinarstyle)
    assert @webinar
    @user = FactoryGirl.create(:normal_user)
    assert @user
    @admin = FactoryGirl.create(:admin_user)
    assert @admin
  end

  test 'two users should not have same username' do
    e1 = User.new
    e2 = User.new
    e1.username = 'john.doe'
    e1.email = 'john.doe@orasi.com'
    e1.save
    e2.username = 'john.doe'
    e2.email = 'john.doe@orasi.com'
    assert_raises ActiveRecord::RecordInvalid do
      e2.save!
    end
  end
end
