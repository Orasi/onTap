class EventMailer < ActionMailer::Base
  default from: 'from@example.com'
  def event_calendar_invite
    mail(to: User.find(1).email, subject: 'Event Invite', from: 'OrasiEvents@orasi.com') do |format|
      format.ics{
        ical = Icalendar::Calendar.new
        e = self.ical
        #        e.start.icalendar_tzid="UTC"
        # e.dtend = Icalendar::Values::Date.new('20140716')
        #        e.end.icalendar_tzid="UTC"
        #       e.organizer "OrasiEvents@Orasi.com"
        #        e.uid "MeetingRequest1"
        # e.summary "Some Meting"
        # e.description ="Some MEeting"

        ical.add_event(e)
        ical.publish
        ical.to_ical
        render text: ical, layout: false
      }
    end
  end

  def ical
    e = Icalendar::Event.new
    # e.uid=self.uid
    e.dtstart = DateTime.now
    e.dtend = DateTime.now + 1.hour
    e.summary = 'test'
    e.created = DateTime.now
    #  e.last_modified=self.updated_at
    e
  end
end
