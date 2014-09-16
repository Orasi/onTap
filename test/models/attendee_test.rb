require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:lunchlearnstyle)
    @user = FactoryGirl.create(:normal_user)
  end

  test 'attendee should not save with out user_id' do
    attend = @event.attendees.new
    assert_not attend.save
  end

  test 'attendee should not save with out event_id' do
    attend = Attendee.new(user_id: @user.id)
    assert_not attend.save
  end

  test 'attendee should not save unless unique' do
    attend = @event.attendees.create(user_id: @event.attendees.sample.user_id)
    assert_not attend.save
  end

  test 'attendee should be deleted when event is deleted' do
    @event_to_delete = FactoryGirl.create(:lunchlearn)
    event_id = @event_to_delete.id
    @event.destroy
    assert_equal 0, Attendee.where(event_id: event_id).count
  end

  test 'should not be able to attend finalized event' do
    event = FactoryGirl.create(:lunchlearnstyle, :past, :finalized)
    attend =  event.attendees.new(user_id: @user.id)
    assert_not attend.save
  end
end
