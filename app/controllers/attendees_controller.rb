class AttendeesController < ApplicationController
  def change 
    if Event.find(params[:id]).attendees.exists?(user_id: session[:current_user_id])
      Event.find(params[:id]).attendees.find_by(user_id: session[:current_user_id]).destroy
      flash[:error] = "You are no longer attending the event: #{Event.find(params[:id]).title}!"
      redirect_to (:back)
    else
      if Event.find(params[:id]).restricted
        if Event.find(params[id]).attend_requests.exists?(requester_id: session[:current_user_id])
          Event.find(params[id]).attend_requests.find_by(requester_id: session[:current_user_id]).destroy
          flash[:success] = "Cancelled request to attend: #{Event.find(params[:id]).title}!"
          redirect_to (:back)
        else
          #createrequest
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
end
