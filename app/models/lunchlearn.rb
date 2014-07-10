class Lunchlearn < ActiveRecord::Base
  has_many :attendees
  validate :lunch_date_range
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user


  def lunch_date_range
    minimum_date = Date.new(2000)
    maximum_date = Date.new(2050)
    if !lunch_date.blank?
      if minimum_date > lunch_date
	errors.add(:lunch_date, "is before the minimum date of #{minimum_date}.")
      end
      if maximum_date < lunch_date
	errors.add(:lunch_date, "is after the maximum date of #{maximum_date}.")
      end
    end
  end

  def is_attending_event(user)
    self.attendees.exists?(user_id: user.id)
  end

 def is_hosting_event(user)
   self.hosts.exists?(user.id)
 end 

end
