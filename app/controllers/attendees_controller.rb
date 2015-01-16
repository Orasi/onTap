class AttendeesController < ApplicationController
  def change
    if Event.find(params[:id]).attendees.exists?(user_id: session[:current_user_id])
      Event.find(params[:id]).attendees.find_by(user_id: session[:current_user_id]).destroy
      flash[:error] = "You are no longer attending the event: #{Event.find(params[:id]).title}!"
      redirect_to (:back)
      return
    else
      if Event.find(params[:id]).restricted
        if Event.find(params[:id]).notifications.exists?(user_id: session[:current_user_id])
          Event.find(params[:id]).notifications.find_by(user_id: session[:current_user_id]).destroy
          flash[:error] = "Cancelled request to attend: #{Event.find(params[:id]).title}!"
          redirect_to (:back)
          return
        else
          if check_employee_department(params[:id])
            attend_now(params[:id])
            return          
          end
          @notification = Event.find(params[:id]).notifications.create(user_id: session[:current_user_id], status: 'new', notification_type: 'attendance')
          if @notification.save
            flash[:success] = "A request has been sent to attend the event: #{Event.find(params[:id]).title}!"
            redirect_to (:back)
            return
          else
            flash[:error] = "#{Event.find(params[:id]).title} is in the archive."
            redirect_to :calendar
            return
          end
        end
      else
        attend_now(params[:id])
        return
      end
    end
  end

  def attend_now(e_id)
    @attendee = Event.find(e_id).attendees.new(user_id: session[:current_user_id])
    if @attendee.save
      flash[:success] = "You are now attending the event: #{Event.find(e_id).title}!  #{view_context.link_to 'Add To Calendar', event_invite_path(e_id), class: 'invite_link', remote: true}".html_safe
      redirect_to (:back)
      return
    else
      flash[:error] = "#{Event.find(e_id).title} is in the archive."
      redirect_to :calendar
      return
    end
  end

  def check_employee_department(e_id)
    bluesource_name=User.find(session[:current_user_id]).username
    @api_user = YAML.load_file(File.join(Rails.root, 'config', 'bluesource_api.yml'))[Rails.env]
    auth = {:username => @api_user["username"], :password => @api_user["password"]}
    department = HTTParty.get("http://bluesourcestaging.herokuapp.com/api/department.json?q=#{bluesource_name}", :basic_auth => auth)
    Event.find(e_id).department_approvals.each do |department_name, approve_status|
      if (department["name"] == department_name && approve_status=="1")
        return true
      end
    end
    return false
  end

  def approve_attend
    @notification = Notification.find(params[:id])
    @attendee = Event.find(@notification.event_id).attendees.new(user_id: @notification.user_id)
    if @attendee.save
      flash[:success] = "#{User.find(@notification.user_id).display_name} is now attending the event: #{Event.find(@notification.event_id).title}!"
      @notification.update(status: 'approved', manager_id: session[:current_user_id])
      redirect_to (:back)
    else
      flash[:error] = "#{Event.find(@notification.event_id).title} is in the archive."
      redirect_to :calendar
    end
  end

  def reject_attend
    @notification = Notification.find(params[:id])
    @notification.update(status: 'rejected', manager_id: session[:current_user_id])
    flash[:success] = "#{User.find(@notification.user_id).display_name} has been rejected from attending event: #{Event.find(@notification.event_id).title}!"
    redirect_to (:back)
  end
end
