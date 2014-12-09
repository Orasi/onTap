require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'should not create event past max date' do
    event = FactoryGirl.create(:lunchlearnstyle)

    event.schedules.each(&:destroy)

    schedule = event.schedules.new(start: (DateTime.now + 100.years),
                                   'end' => (DateTime.now +100.years + 1.hour))
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end

  test 'should not create event before min date' do
    event = FactoryGirl.create(:lunchlearnstyle)

    event.schedules.each(&:destroy)

    schedule = event.schedules.new(start: (DateTime.now - 100.years),
                                   'end' => (DateTime.now 100.years + 1.hour))
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end

  test 'should not create event end_time < event_time' do
    event = FactoryGirl.create(:lunchlearnstyle)
    start_date = event.schedules.first.start

    end_date = event.schedules.first.end
    event.schedules.each(&:destroy)

    schedule = event.schedules.new(start: end_date,
                                   'end' => start_date)
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end
end
