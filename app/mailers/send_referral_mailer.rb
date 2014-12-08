class SendReferralMailer < ActionMailer::Base
  default from: 'onTapEvents@orasi.com'
  default_url_options[:host] = 'ontap.orasi.com'

  def send_referral_mailer(event, to_list, email_subject, email_body)

    @title = event.title
    @body=email_body
    @description =event.description
    @url = event_url(event)

    mail(to: to_list, subject: email_subject).deliver
  end
end
