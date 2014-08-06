class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :attend_requests
  has_many :attachments
  has_many :requests
  has_one :event_style
  has_one :lunchlearns, :through => :event_style, :source => :element, :source_type => 'lunchlearn'
  has_one :webinars, :through => :event_style, :source => :element, :source_type => 'webinar'
  attr_accessor :has_GoToMeeting, :go_to_meeting_url, :meeting_phone_number, :access_code, :url


  def attending_event?(user)
    self.attendees.exists?( user_id: user.id )
  end

  def hosting_event?(user)
    self.hosts.exists?( user_id: user.id )
  end 

  def attend_button_text(user)
    if attending_event?(user)
      return "Don't Attend"
    elsif self.restricted && self.requests.exists?(user_id: user.id)
      return "Cancel Request"
    elsif self.restricted
      return "Request something"
    else
      return "Attend"
    end    
  end

end
