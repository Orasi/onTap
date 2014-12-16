require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  test 'notification can be created' do
    @notify = FactoryGirl.create(:notification, :new)
    assert @notify
  end

  test 'notification can not be created with blank status' do
    @notify = FactoryGirl.build(:notification, :no_status)
    assert_not @notify.valid?
  end

  test 'notification can not be created with invalid status' do
    @notify = FactoryGirl.build(:notification, :wrong_status)
    assert_not @notify.valid?
  end

  test 'notification can not be created without type' do
    @notify = FactoryGirl.build(:notification, :no_type)
    assert_not @notify.valid?
  end

  test 'notification can not be created with invalid type' do
    @notify = FactoryGirl.build(:notification, :invalid_type)
    assert_not @notify.valid?
  end

  test 'notification cleanup removes old notifications' do
    @notify = FactoryGirl.create(:notification, :old)
    assert @notify
    notification_count = Notification.all.count
    Notification.notification_cleanup
    assert_equal notification_count, (Notification.all.count -1)
  end
end
