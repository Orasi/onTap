class EventUpdatedMailer < ActionMailer::Base
  default from: 'onTapEvents@orasi.com'
  default_url_options[:host] = 'ontap.orasi.com'

  def event_updated_mailer(event)
    return unless event.type.class::ATTENDABLE
    @title = event.title
    @url = event_url(event.id)
    emails = []
    User.find(event.attendees.pluck(:user_id)).each do |user|
      emails.push user.email
    end
    mail(to: emails, subject: "Event '#{@title}' has been updated").deliver
  end
end
