require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
  end

  test 'should save event' do
    event = FactoryGirl.build(:lunchlearnstyle)
    assert event.save, message:  event.errors.full_messages
  end

  test 'should delete event' do
    event = FactoryGirl.create(:lunchlearnstyle)
    event_id = event.id
    assert event.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      Event.find(event_id)
    end
  end

  test 'should not create event with out title' do
    event = FactoryGirl.build(:lunchlearnstyle, title: nil)
    assert_raises ActiveRecord::RecordInvalid do
      event.save!
    end
  end

  test 'should not create event with out description' do
    event = FactoryGirl.build(:lunchlearnstyle, description: nil)
    assert_raises ActiveRecord::RecordInvalid do
      event.save!
    end
  end

  test 'should display correct button text if not attending' do
    event = FactoryGirl.create(:lunchlearnstyle)
    assert_equal event.attend_button_text(FactoryGirl.create(:normal_user)), 'Attend'
  end

  test 'should display correct button text if not attending restricted event' do
    event = FactoryGirl.create(:lunchlearnstyle, :restricted)
    assert_equal event.attend_button_text(FactoryGirl.create(:normal_user)), 'Request To Attend'
  end

  test 'should display correct button text if attending' do
    event = FactoryGirl.create(:lunchlearnstyle)
    user = FactoryGirl.create(:normal_user)
    event.attendees.create(user_id: user.id)
    assert_equal event.attend_button_text(user), "Don't Attend"
  end

  test 'should display correct button text if requested to attend restricted event' do
    event = FactoryGirl.create(:lunchlearnstyle, :restricted)
    user = FactoryGirl.create(:normal_user)
    event.notifications.create(user_id: user.id, status: 'new', notification_type: 'attendance')
    assert_equal event.attend_button_text(user), 'Cancel Request'
  end

  test 'should correctly identify event older than x' do
    event = FactoryGirl.create(:lunchlearnstyle, :past)
    assert event.older_than_days 4
  end

  test 'should correctly identify not older than x' do
    event = FactoryGirl.create(:lunchlearnstyle, :past)
    assert_not event.older_than_days 5
  end

  test 'should generate ical' do
    event = FactoryGirl.create(:lunchlearnstyle)
    assert event.ical_attachment
  end

  test 'should get food preferences' do
    event = FactoryGirl.create(:lunchlearnstyle)
    event.attendees.first.user.profile.update(food_pref: 'i eat hotdogs')
    assert_includes event.get_food_preferences, 'i eat hotdogs'
  end
end
