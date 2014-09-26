class WeeklyMailer < ActionMailer::Base
  default from: "onTapEvents@orasi.com"
  default_url_options[:host] = '10.238.242.85:3000'

  def weekly_mailer(users)
    @weeks_events = Event.joins(:schedules).merge(Schedule.where('event_date >= ? AND event_date < ?', DateTime.now.to_date,  DateTime.now.to_date + 7.days))
    @days = Hash.new
    @days[:monday] = []
    @days[:tuesday] = []
    @days[:wednesday] = []
    @days[:thursday] = []
    @days[:friday] = []
    @weeks_events.each do |event|
      day_of_week = Date::DAYNAMES[event.schedules.first.event_date.wday].downcase.to_sym
      @days[day_of_week].append event
    end
    
    mail(to: users.pluck(:email), subject: 'Events onTap This Week')

  end
end
