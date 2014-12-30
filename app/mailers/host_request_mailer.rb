class HostRequestMailer < ActionMailer::Base
  default from: 'onTapEvents@orasi.com'
  default_url_options[:host] = 'ontap.orasi.com'

  def host_request_mailer(to_list, email_subject, email_body)

    @body=email_body

    mail(to: to_list, subject: email_subject).deliver
  end
end
