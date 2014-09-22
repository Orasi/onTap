class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :surveys
  has_many :attachments
  has_many :notifications
  has_one :event_style
  # has_one :lunchlearns, :through => :event_style, :source => :element, :source_type => 'lunchlearn'
  # has_one :webinars, :through => :event_style, :source => :element, :source_type => 'webinar'
  validates_presence_of :title, :description
  attr_accessor :has_GoToMeeting, :go_to_meeting_url, :meeting_phone_number, :access_code, :url

  def attending_event?(user)
    attendees.exists?(user_id: user.id)
  end

  def hosting_event?(user)
    hosts.exists?(user_id: user.id)
  end

  def past?
    return false if schedules.last.event_date > DateTime.now.to_date
    return true if schedules.last.event_date < DateTime.now.to_date
    if schedules.last.event_time.hour == DateTime.now.to_time.hour
      if schedules.last.event_time.min > DateTime.now.to_time.min
        return true
      else 
        return false
      end
    elsif schedules.last.event_time.hour < DateTime.now.to_time.hour
      return true
    elsif schedules.last.event_time.hour > DateTime.now.to_time.hour
      return false
    end
  end

  def attend_button_text(user)
    if attending_event?(user)
      return "Don't Attend"
    elsif restricted && notifications.exists?(user_id: user.id)
      return 'Cancel Request'
    elsif restricted
      return 'Request To Attend'
    else
      return 'Attend'
    end
  end

  def attending_or_above?(user)
    attendees.exists?(user_id: user.id) || hosting_or_above?(user)
  end

  def hosting_or_above?(user)
    hosts.exists?(user_id: user.id) || user.admin?
  end

  def type
    event_style.element
  end
end
