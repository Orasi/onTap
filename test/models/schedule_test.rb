require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  test 'should not create event past max date' do
    event = FactoryGirl.create(:lunchlearnstyle)
    
    event.schedules.each do |s|
      s.destroy
    end
    
    schedule = event.schedules.new(event_date: (DateTime.now + 100.years).to_date, event_time: DateTime.now.to_time, end_time: (DateTime.now + 1.hour).to_time)
    assert_raises ActiveRecord::RecordInvalid do
       schedule.save!
    end
  end

  test 'should not create event before min date' do
    event = FactoryGirl.create(:lunchlearnstyle)
    
    event.schedules.each do |s|
      s.destroy
    end
    
    schedule = event.schedules.new(event_date: (DateTime.now - 100.years).to_date, event_time: DateTime.now.to_time, end_time: (DateTime.now + 1.hour).to_time)
    assert_raises ActiveRecord::RecordInvalid do
       schedule.save!
    end
  end

  test 'should not create event end_time < event_time' do
    event = FactoryGirl.create(:lunchlearnstyle)
    start_time = event.schedules.first.event_time
    end_time = event.schedules.first.end_time
    event_date = event.schedules.first.event_date
    event.schedules.each do |s|
      s.destroy
    end
    
    schedule = event.schedules.new(event_date: event_date, event_time: end_time, end_time: start_time)
    assert_raises ActiveRecord::RecordInvalid do
       schedule.save!
    end
  end
end
