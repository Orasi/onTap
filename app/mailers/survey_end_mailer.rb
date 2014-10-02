class SurveyEndMailer < ActionMailer::Base
  default from: "onTapEvents@orasi.com"
  default_url_options[:host] = 'ontap.orasi.com'

  def survey_end_mailer(event)
    return unless event.type.class::ATTENDABLE
    return if event.hosts.first.external

    @title = event.title
    @url = surveys_url(id: event)
    emails = []

    User.find(event.hosts.pluck(:user_id)).each do |user|
      emails.push user.email
    end
    mail(to: emails, subject: "Survey Finalized for Event '#{@title}'")

  end
end