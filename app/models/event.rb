class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :attachments
  has_one :event_style
  #has_one :lunchlearns, :through => :event_style, :source => :element, :source_type => 'lunchlearn'
  #has_one :webinars, :through => :event_style, :source => :element, :source_type => 'webinar'
  
  attr_accessor :has_GoToMeeting, :go_to_meeting_url, :meeting_phone_number, :access_code, :url


  def attending_event?(user)
    self.attendees.exists?( user_id: user.id ) 
  end

  def hosting_event?(user)
    self.hosts.exists?( user_id: user.id )
  end 
  
  def attending_or_above?(user)
    self.attendees.exists?( user_id: user.id ) || hosting_or_above?(user)
  end

  def hosting_or_above?(user)
    self.hosts.exists?( user_id: user.id ) || user.admin?
  end

  def type
    self.event_style.element
  end

end
