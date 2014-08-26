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
end
