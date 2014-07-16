require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  def setup 
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    @event = Lunchlearn.create(title: "Forward Usability Representative", description: "Try to reboot the HDD capacitor, maybe it will conn...", created_at: "2014-07-15 03:20:14", updated_at: "2014-07-15 03:20:14", lunch_date: DateTime.now.to_date, lunch_time: "2000-01-01 02:41:22", meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: "2000-01-01 03:41:22")
    @user = User.create(created_at: "2014-07-15 03:19:57", updated_at: "2014-07-15 03:19:57", username: first_name + "." + last_name, first_name: first_name, last_name: last_name, admin: false, photo: nil, email: "matt.watson@orasi.com")
  end

  test "attendee should not save with out user_id" do
    attend = Attendee.new(lunchlearn_id: 1)
    assert_not attend.save
  end

  test 'attendee should not save with out lunchlearn_id' do 
    attend = Attendee.new(user_id: 1)
    assert_not attend.save
  end

  test 'attendee should not save unless unique' do 
    @event.attendees.create(user_id: @user.id)
    attend = @event.attendees.create(user_id: @user.id)
    assert_not attend.save
  end
  
  test 'attendee should be deleted when event is deleted' do
    @event.attendees.create(user_id: @user.id)
    event_id = @event.id
    @event.destroy
    assert_equal 0,Attendee.where(lunchlearn_id: event_id).count
  end

  test 'should not be able to attend past event' do
    event = lunchlearns(:lunchthree)
    attend =  event.attendees.new(user_id: @user.id)
    assert_not attend.save
  end
  
end
