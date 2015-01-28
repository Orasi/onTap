class Event < ActiveRecord::Base
  has_many :hosts
  has_many :lunch_hosts, through: :hosts, source: :user
  has_many :attendees
  has_many :schedules
  has_many :surveys
  has_many :attachments
  has_many :notifications
  has_one :event_style
  accepts_nested_attributes_for :schedules, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  # has_one :lunchlearns, :through => :event_style, :source => :element, :source_type => 'lunchlearn'
  # has_one :webinars, :through => :event_style, :source => :element, :source_type => 'webinar'
  validates_presence_of :title, :description
  serialize :visible_to_departments, Hash
  serialize :department_approvals, Hash
  attr_accessor :has_GoToMeeting, :go_to_meeting_url, :meeting_phone_number, :access_code, :url, :location

  def get_department_array

    template = ERB.new File.new("config/bluesource_api.yml").read
    @api_user = YAML.load template.result(binding)
    #@api_user = YAML.load_file(File.join(Rails.root, 'config', 'bluesource_api.yml'))[Rails.env]
    auth = {:username => @api_user[Rails.env]["username"], :password => @api_user[Rails.env]["password"]}
    begin
      department_list = HTTParty.get("http://bluesourcestaging.herokuapp.com/api/department_list.json?", :basic_auth => auth)
      return department_list
    rescue 
      return ""
    end
  end

  def lab
    if lab_id.nil?
      return nil
    else
      return Template.find(lab_id)
    end
  end

  def attending_event?(user)
    attendees.exists?(user_id: user.id)
  end

  def hosting_event?(user)
    hosts.exists?(user_id: user.id)
  end

  def past?
    schedules.sort_by(&:start).last.end <= DateTime.now - 5.hours
  end

 # def upcoming_dates
 #   return schedules.where("schedules.end >= ?", DateTime.now)
 # end

  def next_date
    @schedule=schedules.where("schedules.end >= ?", DateTime.now).sort_by(&:start).first
    if @schedule.nil?
      return schedules.sort_by(&:start).first
    else
      return @schedule
    end
  end

  def jumbo_dates(c_user)
    if schedules.count == 1
      if schedules.first.start.strftime("%d") != schedules.first.end.strftime("%d")
        return  schedules.first.start.strftime("%B %d, %Y from %I:%M %p") + ' until ' + schedules.first.end.strftime("%B %d, %Y %I:%M %p")
      else
        return  schedules.first.start.strftime("%B %d, %Y from %I:%M %p") + ' until ' + schedules.first.end.strftime("%I:%M %p")
      end
    elsif schedules.count > 1
      scheds=schedules.sort_by(&:start)
      if consecutive_days?
        if time_same?
          return scheds.first.start.strftime("%B") + " "+ scheds.first.start.strftime("%d")+"-" + scheds.last.start.strftime("%d") + ", "+ scheds.last.start.strftime("%I:%M %p")+ " until "+ scheds.last.end.strftime("%I:%M %p")
        else
          return scheds.first.start.strftime("%B") + " "+ scheds.first.start.strftime("%d")+"-" + scheds.last.start.strftime("%d")
        end
      else
        if time_same?
          return build_nonconsecutive + ", " + scheds.last.start.strftime("%I:%M %p")+ " until "+ scheds.last.end.strftime("%I:%M %p")
        else
          return build_nonconsecutive
        end
      end
    end
  end

  def build_nonconsecutive
    month_string = ""
    schedule_string= ""
    the_month = ""
    hash=Hash.new
    schedules.sort_by(&:start).each do |schedule|
      if(the_month.blank?)
        the_month=schedule.start.strftime("%B").to_s
      end
      if(the_month==schedule.start.strftime("%B"))
        month_string = month_string + schedule.start.strftime("%d").to_s+","
      else
        month_string=month_string.chomp(",")
        schedule_string=schedule_string+the_month+" "+month_string +"<br/>"
        month_string = schedule.start.strftime("%d").to_s+","
        the_month = schedule.start.strftime("%B").to_s
      end
    end
    month_string=month_string.chomp(",")
    schedule_string=schedule_string+the_month+" "+month_string
    
    return schedule_string.html_safe
  end

  def consecutive_days?
    prev_day=0
    date_month=schedules.first.start.strftime("%B")
    schedules.sort_by(&:start).each do |schedule|
      if date_month != schedule.start.strftime("%B")
        return false
      end
      if(prev_day==0)
        prev_day=schedule
      else
        if(((prev_day.start) +1.day).to_date == schedule.start.to_date)
          prev_day=schedule
        else
          return false
        end
      end
    end
    return true
  end

  def time_same?
    stime=schedules.first.start.strftime("%I:%M %p")
    etime=schedules.first.end.strftime("%I:%M %p")
    schedules.sort_by(&:start).each do |day|
      if stime != day.start.strftime("%I:%M %p")
        return false
      end
      if etime != day.end.strftime("%I:%M %p")
        return false
      end
    end
    return true
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
      @user = User.find(attendee.user_id)
      unless @user.profile.nil?
        if @user.profile.food_pref == 'Other'
          unless @user.profile.other_food.nil?
            if food_hsh['Other'].nil?
              food_hsh['Other'] = @user.profile.other_food
            else
              food_hsh['Other'] += ', ' + @user.profile.other_food
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
    food_hsh
  end

  def ical_attachment

    cal = Icalendar::Calendar.new

    event = Icalendar::Event.new
    event.dtstart    =  self.schedules.first.start
    event.dtend       = self.schedules.last.end
    event.summary      = title
    event.description  = description

    cal.add_event(event)
    cal.publish

    # Required To Show Up in Outlook
    cal.to_ical.gsub("ORGANIZER:", "ORGANIZER;").gsub("ACCEPTED:", "ACCEPTED;").gsub("TRUE:", "TRUE;").gsub("PUBLISH", "REQUEST")
  end

  def update_attendees_email()
    EventUpdatedMailer.event_updated_mailer(self)
  end

  def self.event_type_totals
    @events=Event.all
    hash = {}
    @events.each do |event|
      if hash[event.event_style.element_type].nil?
        hash[event.event_style.element_type]=1
      else
        hash[event.event_style.element_type]=hash[event.event_style.element_type]+1
      end
    end
    return hash
  end

  def self.event_attendees_total
    @events=Event.all
    total=0
    @events.each do |event|
      total+=event.attendees.count
    end
    return total
  end

  def self.event_attendees_average
    @events=Event.all
    total=0
    events_total=0
    @events.each do |event|
      if event.type.class::ATTENDABLE
        events_total+=1
        total+=event.attendees.count
      end
    end
    if events_total != 0
      return total/events_total
    else
      return 0
    end
  end

  def can_view_event?(u_id)
    if !limited_visibility
      return true
    end
    department=User.find(u_id).get_user_department
    if(visible_to_departments.has_key?(department) && (visible_to_departments[department] == "1"))
      return true
    end
    return false
  end
end
