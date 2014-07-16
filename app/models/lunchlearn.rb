class Lunchlearn < ActiveRecord::Base
  has_many :attendees, dependent: :destroy
  validates :title, :description, presence: true
  validate :lunch_date_range
  validate :event_time_order_check
  has_many :hosts, dependent: :destroy
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attachments, dependent: :destroy


  def lunch_date_range
    minimum_date = Date.new(2000)
    maximum_date = Date.new(2050)
    if !lunch_date.blank?
      if minimum_date > lunch_date
	errors.add(:lunch_date, "#{lunch_date} is before the minimum date of #{minimum_date}.")
      end
      if maximum_date < lunch_date
	errors.add(:lunch_date, "#{lunch_date} is after the maximum date of #{maximum_date}.")
      end
    end
  end

  def event_time_order_check
    if !end_time.blank?
      if lunch_time.strftime("%H%M") > end_time.strftime("%H%M")
        errors.add(:lunch_time, "Start time must be before end time")
      end
    end
  end

  def is_attending_event(user)
    self.attendees.exists?( user_id: user.id )
  end

 def is_hosting_event(user)
   self.hosts.exists?( user_id: user.id )
 end 

end
