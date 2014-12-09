class Schedule < ActiveRecord::Base
  validate :event_date_range, :start_before_end
  #  validate :event_time_order_check
  #validates_datetime :end, after: :start, after_message: 'time must be after start time.'
  belongs_to :event

  def start_before_end
    if self.end < self.start
      return false
    else
      return true
    end
  end

  def event_date_range
    minimum_date = Date.new(2000)
    maximum_date = Date.new(2050)
    unless start.blank? || self.end.blank?
      if minimum_date > start
        errors.add(:start, "#{start} is before the minimum date of #{minimum_date}.")
        return false
      end
      if maximum_date < self.end
        errors.add(:end, "#{self.end} is after the maximum date of #{maximum_date}.")
        return false
      end
    end
  end
end
