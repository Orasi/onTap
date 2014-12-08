
class CalendarInvite < ActionMailer::Base
  default from: "onTapEvents@orasi.com"
  def invitation_email(event, users)

    if users.class == User
      email = users.email
    else
      email = users.map{|user| user.email}
    end

    subject = 'Invite: ' + event.title
    email = mail( to: email, subject: subject)

    add_html_part_to(email)
    add_ical_part_to(email, event)
    wrap_exisiting_mail_parts_in_multipart_alternative(email)
    wrap_mail_in_multipart_mixed(email)

    attachments["invite.ics"] = { mime_type: "application/ics",
                                  content: event.ical_attachment }
    email
  end

  def add_html_part_to(mail)
    html_body = render("invitation_email", handlers: ["erb"], formats: ["html"])
    mail.add_part(Mail::Part.new do
      content_type "text/html"
      body html_body
    end)
  end

  def add_ical_part_to(mail, event)
    outlook_body = event.ical_attachment
    mail.add_part(Mail::Part.new do
      content_type "text/calendar; method=REQUEST"
      body outlook_body
    end)
  end

  def wrap_exisiting_mail_parts_in_multipart_alternative(mail)
    mail.add_part(Mail::Part.new do
      content_type "multipart/alternative"
      mail.parts.delete_if { |p| add_part(p) }
    end)
  end

  def wrap_mail_in_multipart_mixed(mail)
    mail.content_type = "multipart/mixed"
    mail.header["content-type"].parameters[:boundary] = mail.body.boundary
  end

end
