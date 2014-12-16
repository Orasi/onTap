require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  def setup
    @event = FactoryGirl.create(:lunchlearnstyle)
    assert @event
  end

  test 'should not create event past max date' do
    @event.schedules.each(&:destroy)

    schedule = @event.schedules.new(start: (DateTime.now + 100.years),
                                   'end' => (DateTime.now +100.years + 1.hour))
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end

  test 'should not create event before min date' do
    @event.schedules.each(&:destroy)

    schedule = @event.schedules.new(start: (DateTime.now - 100.years),
                                   'end' => (DateTime.now 100.years + 1.hour))
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end

  test 'should not create event end_time < event_time' do
    start_date = @event.schedules.first.start

    end_date = @event.schedules.first.end
    @event.schedules.each(&:destroy)

    schedule = @event.schedules.new(start: end_date,
                                   'end' => start_date)
    assert_raises ActiveRecord::RecordInvalid do
      schedule.save!
    end
  end
end
