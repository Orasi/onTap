class AttendeesController < ApplicationController
  def change 
    if Lunchlearn.find(params[:id]).attendees.exists?(user_id: session[:current_user_id])
      Lunchlearn.find(params[:id]).attendees.find_by(user_id: session[:current_user_id]).destroy
      redirect_to controller: :lunchlearns, action: :calendar
    else
      Lunchlearn.find(params[:id]).attendees.create(user_id: session[:current_user_id])
      redirect_to controller: :lunchlearns, action: :calendar
    end
   
  end
end
