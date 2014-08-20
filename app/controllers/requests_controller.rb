class RequestsController < ApplicationController

  def index
    #will need to add on restriction here when managers table added
    @notifications=Request.where( notification_type: "attendance", status: "new")
    @acceptedrequests=Request.where(user_id: session[:current_user_id], status: "approved", notification_type: "attendance")
    @rejectedrequests=Request.where(user_id: session[:current_user_id], status: "rejected", notification_type: "attendance")
  end

  def destroy
    @notification=Request.find(params[:id])
    @notification.destroy
    redirect_to (:back)
  end

end
