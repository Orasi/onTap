require 'test_helper'

class ReferralTest < ActiveSupport::TestCase

   test 'referal can be created with single email' do
     @good = FactoryGirl.create(:referral)
     assert @good
   end

  test 'referal can be created with multiple emails' do
    @multiple = FactoryGirl.create(:referral, :multiple)
    assert @multiple
  end

  test 'referral can be created with non-orasi email' do
    @non_orasi = FactoryGirl.create(:referral, :non_orasi)
    assert_not @non_orasi
  end

  test 'referal can not be created with poorly formed email' do
    @worse = FactoryGirl.create(:referral, :worse)
    assert_not @worse
    @worst = FactoryGirl.create(:referral, :worst)
    assert_not @worst
  end
  
end
