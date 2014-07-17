class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :event_styles
  has_one :lunchlearn, :through => :event_styles, :source => :element, :source_type => 'LunchLearn'
  has_one :webinar, :through => :event_styles, :source => :element, :source_type => 'Webinar'

  def is_attending_event(user)
    self.attendees.exists?( user_id: user.id )
  end

 def is_hosting_event(user)
   self.hosts.exists?( user_id: user.id )
 end 

end
