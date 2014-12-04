
class UserEmail < ActionMailer::Base
  default from: 'onTapEvents@orasi.com'
  default_url_options[:host] = 'ontap.orasi.com'

  def user_email(to, subject, body)
    mail(to: to, subject: subject, body: body).deliver
  end
end
