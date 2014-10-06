class FinalizeEventMailer < ActionMailer::Base

  default from: "onTapEvents@orasi.com"
  default_url_options[:host] = 'ontap.orasi.com'

  def finalize_event_mailer
    to = User.where(admin: true)
    Event.where(status: nil).each do |event|
      if event.older_than_days(1.day) && event.past?

        @title = event.title
        @url = event_url(event)

        mail(to: to, subject: "Event '#{@title}' Requires Attention - Please Finalize").deliver
      end
    end
  end

end