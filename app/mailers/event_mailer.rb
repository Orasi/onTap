class EventMailer < ActionMailer::Base
  default from: "from@example.com"
  def event_calendar_invite
    mail(to: User.find(1).email, subject: "Event Invite", from: "OrasiEvents@orasi.com") do |format|
      format.ics{
        ical = Icalendar::Calendar.new
        e = Icalendar::Event.new
        e.dtstart = Icalendar::Values::Date.new('20140715')

#        e.start.icalendar_tzid="UTC"
        e.dtend = Icalendar::Values::Date.new('20140716')
#        e.end.icalendar_tzid="UTC"
 #       e.organizer "OrasiEvents@Orasi.com"
#        e.uid "MeetingRequest1"
        e.summary "Some Meting"
        e.description ="Some MEeting"
     
        ical.add_event(e)
        ical.publish
        ical_to_ical
       render :text => ical, layout: false
      }
    end
  end

def ical
  e=Icalendar::Event.new
  e.uid=self.uid    
  e.dtstart=DateTime.civil(self.date_start.year, self.date_start.month, self.date_start.day, self.date_start.hour, self.date_start.min)    
  e.dtend=DateTime.civil(self.date_end.year, self.date_end.month, self.date_end.day, self.date_end.hour, self.date_end.min)    
  e.summary=self.name    
  e.created=self.created_at    
  e.url=self.url    
  e.last_modified=self.updated_at    
  e   
end
end
