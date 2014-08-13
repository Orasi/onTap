class Schedule < ActiveRecord::Base
  validate :event_date_range
#  validate :event_time_order_check
  validates_datetime :end_time, :after => :event_time
  belongs_to :event

  def event_date_range
    minimum_date = Date.new(2000)
    maximum_date = Date.new(2050)
    unless event_date.blank?
      if minimum_date > event_date
	errors.add(:event_date, "#{event_date} is before the minimum date of #{minimum_date}.")
        return false
      end
      if maximum_date < event_date
	errors.add(:event_date, "#{event_date} is after the maximum date of #{maximum_date}.")
        return false
      end
    end
  end

  def event_time_order_check
    unless end_time.blank?
      if event_time > end_time
        errors.add(:event_time, "Start time must be before end time")
        return false
      end
    end
  end
end
