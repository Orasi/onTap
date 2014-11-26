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
    return schedules.last.end <= DateTime.now - 5.hours
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

  def attendees_email
    if attendees
      User.where(id: attendees.pluck(:user_id)).pluck(:email)
    end
  end

  def older_than_days(days)
    schedules.last.end.to_date < DateTime.now.to_date - days
  end

  def get_food_preferences
    food_hsh = {}
    attendees.each do |attendee|
      @user=User.find(attendee.user_id)
      unless @user.profile.nil?
        if @user.profile.food_pref == "Other"
          unless @user.profile.other_food.nil?
            if food_hsh["Other"].nil?
              food_hsh["Other"] = @user.profile.other_food
            else
              food_hsh["Other"] += ", "+@user.profile.other_food
            end
          end
        else
          if food_hsh[@user.profile.food_pref].nil?
            food_hsh[@user.profile.food_pref] = 1
          else
            food_hsh[@user.profile.food_pref] += 1
          end
        end
      end
    end
    return food_hsh
  end
end
