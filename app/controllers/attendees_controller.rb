class AttendeesController < ApplicationController
  def change 
    if Event.find(params[:id]).attendees.exists?(user_id: session[:current_user_id])
      Event.find(params[:id]).attendees.find_by(user_id: session[:current_user_id]).destroy
      flash[:error] = "You are no longer attending the event: #{Event.find(params[:id]).title}!"
      redirect_to (:back)
    else
      if Event.find(params[:id]).restricted
        if Event.find(params[:id]).requests.exists?(user_id: session[:current_user_id])
          Event.find(params[:id]).requests.find_by(user_id: session[:current_user_id]).destroy
          flash[:success] = "Cancelled request to attend: #{Event.find(params[:id]).title}!"
          redirect_to (:back)
        else
          @request=Event.find(params[:id]).requests.create(user_id: session[:current_user_id], notification_type: 0)
          if @request.save
            flash[:success] = "A request has been sent to attend the event: #{Event.find(params[:id]).title}!"
            redirect_to (:back)
          else
            flash[:error] = "#{Event.find(params[:id]).title} is in the archive."
            redirect_to :calendar
          end
        end
      else
        @attendee=Event.find(params[:id]).attendees.new(user_id: session[:current_user_id])
        if @attendee.save
          flash[:success] = "You are now attending the event: #{Event.find(params[:id]).title}!"
          redirect_to (:back)
        else
          flash[:error] = "#{Event.find(params[:id]).title} is in the archive."
          redirect_to :calendar
        end
      end
    end   
  end

  def approve_attend
    @notification=Request.find(params[:id])
    @attendee=Event.find(@notification.event_id).attendees.new(user_id: @notification.user_id)
    if @attendee.save
      flash[:success] = "#{User.find(@notification.user_id).display_name} is now attending the event: #{Event.find(@notification.event_id).title}!"
      @notification.destroy
      redirect_to (:back)
    else
      flash[:error] = "#{Event.find(@notification.event_id).title} is in the archive."
      redirect_to :calendar
    end
  end
end
