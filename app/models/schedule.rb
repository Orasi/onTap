class Schedule < ActiveRecord::Base
  validate :event_date_range
  validate :event_time_order_check
  belongs_to :event
  def event_date_range
    minimum_date = Date.new(2000)
    maximum_date = Date.new(2050)
    unless event_date.blank?
      if minimum_date > event_date
	errors.add(:event_date, "#{event_date} is before the minimum date of #{minimum_date}.")
      end
      if maximum_date < event_date
	errors.add(:event_date, "#{event_date} is after the maximum date of #{maximum_date}.")
      end
    end
  end

  def event_time_order_check
    unless end_time.blank?
      if event_time.strftime("%H%M") > end_time.strftime("%H%M")
        errors.add(:event_time, "Start time must be before end time")
      end
    end
  end
end
