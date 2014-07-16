require 'test_helper'

class LunchlearnTest < ActiveSupport::TestCase

  test 'should save event' do
    random_start = rand(-1.years..1.years).ago
    random_end = random_start + rand(1..5).hours
    if random_start.to_time.hour > random_end.to_time.hour
      start_time = random_end.to_time
      end_time = random_start.to_time
    else
      start_time = random_start.to_time
      end_time = random_end.to_time
    end
    @event = Lunchlearn.new( title: Faker::Name.title, description: Faker::Hacker.say_something_smart, lunch_date: random_start.to_date, lunch_time: start_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: end_time)
    assert @event.save, message:  @event.errors.full_messages
  end

  test 'should delete event' do
    random_start = rand(-1.years..1.years).ago
    random_end = random_start + rand(1..5).hours
    if random_start.to_time.hour > random_end.to_time.hour
      start_time = random_end.to_time
      end_time = random_start.to_time

    else
      start_time = random_start.to_time
      end_time = random_end.to_time
    end
    event = Lunchlearn.new( title: Faker::Name.title, description: Faker::Hacker.say_something_smart, lunch_date: random_start.to_date, lunch_time: start_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: end_time)

    assert event.save message:  event.errors.full_messages
    event_count = Lunchlearn.all.count
    assert event.destroy
    assert_equal event_count - 1, Lunchlearn.all.count
  end
 
  test 'should not create event with out title' do
    random_start = rand(-1.years).ago
    random_end = random_start + rand(1..5).hours
    event = Lunchlearn.new(description: Faker::Hacker.say_something_smart, lunch_date: random_start.to_date, lunch_time: random_start.to_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: random_end.to_time)
    assert_raises ActiveRecord::RecordInvalid do
       event.save!
    end
  end

  test 'should not create event with out description' do
    random_start = rand(-1.years..1.years).ago
    random_end = random_start + rand(1..5).hours
    event = Lunchlearn.new(title: Faker::Name.title, lunch_date: random_start.to_date, lunch_time: random_start.to_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: random_end.to_time)
    assert_raises ActiveRecord::RecordInvalid do
       event.save!
    end
  end

  test 'should not create event past max date' do
    random_start = rand(-1.years..1.years).ago
    random_end = random_start + rand(1..5).hours
    if random_start.to_time.hour > random_end.to_time.hour
      start_time = random_end.to_time
      end_time = random_start.to_time

    else
      start_time = random_start.to_time
      end_time = random_end.to_time
    end
    event = Lunchlearn.new(title: Faker::Name.title, lunch_date: (DateTime.now + 100.years).to_date, lunch_time: start_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: end_time)
     assert_raises ActiveRecord::RecordInvalid do
       event.save!
    end
  end

  test 'should not create event before min date' do
 random_start = rand(-1.years..1.years).ago
    random_end = random_start + rand(1..5).hours
    if random_start.to_time.hour > random_end.to_time.hour
      start_time = random_end.to_time
      end_time = random_start.to_time

    else
      start_time = random_start.to_time
      end_time = random_end.to_time
    end
    event = Lunchlearn.new(title: Faker::Name.title, lunch_date: (DateTime.now - 100.years).to_date, lunch_time: start_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: end_time)
     assert_raises ActiveRecord::RecordInvalid do
       event.save!
    end
  end

end
