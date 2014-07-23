class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :attachments
  has_one :event_style
  has_one :lunchlearns, :through => :event_style, :source => :element, :source_type => 'lunchlearn'
  has_one :webinars, :through => :event_style, :source => :element, :source_type => 'webinar'
  attr_accessor :title, :description, :lunch_date, :lunch_time, :has_GoToMeeting, :go_to_meeting_url, :meeting_phone_number, :access_code

  def attending_event?(user)
    self.attendees.exists?( user_id: user.id )
  end

 def hosting_event?(user)
   self.hosts.exists?( user_id: user.id )
 end 

end
