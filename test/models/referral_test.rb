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
    @non_orasi = FactoryGirl.build(:referral, :non_orasi)
    assert_not @non_orasi.valid?
  end

  test 'referal can not be created with poorly formed email' do
    @worse = FactoryGirl.build(:referral, :worse)
    assert_not @worse.valid?
    @worst = FactoryGirl.build(:referral, :worst)
    assert_not @worst.valid?
  end

end
