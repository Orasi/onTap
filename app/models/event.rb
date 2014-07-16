class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees

  has_many :event_styles
  has_many :lunchlearns, through => :event_styles, :source => :element, :source_type => 'LunchLearn'
  has_many :webinars, through => :event_styles, :source => :element, :source_type => 'LunchLearn'

  def is_attending_event(user)
    self.attendees.exists?( user_id: user.id )
  end

 def is_hosting_event(user)
   self.hosts.exists?( user_id: user.id )
 end 

end
