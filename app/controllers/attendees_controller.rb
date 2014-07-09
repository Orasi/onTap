class AttendeesController < ApplicationController
  def change 
    if Lunchlearn.find(params[:id]).attendees.exists?(user_id: session[:current_user_id])
      Lunchlearn.find(params[:id]).attendees.find_by(user_id: session[:current_user_id]).destroy

      flash[:error] = "You are no longer attending the event: #{Lunchlearn.find(params[:id]).title}!"
      redirect_to (:back)
    else
      Lunchlearn.find(params[:id]).attendees.create(user_id: session[:current_user_id])
      flash[:success] = "You are now attending the event: #{Lunchlearn.find(params[:id]).title}!"
       redirect_to (:back)

    end
   
  end
end
