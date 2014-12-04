class SurveyMailer < ActionMailer::Base
  default from: 'onTapEvents@orasi.com'
  default_url_options[:host] = 'ontap.orasi.com'

  def survey_mailer(event)
    return unless event.type.class::ATTENDABLE
    @title = event.title
    @url = new_survey_url(event_id: event.id)
    emails = []
    User.find(event.attendees.where(status: 'attended').pluck(:user_id)).each do |user|
      emails.push user.email
    end
    mail(to: emails, subject: "Thank you for Attending '#{@title}'")
  end
end
