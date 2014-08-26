class UsersController < ApplicationController
  def new
	   # @user = User.new
	   # puts login_params["username"]
  end

  def notifications
    # will need to add on restriction here when managers table added
    @notifications = Request.where(notification_type: 0, status: 0)
    @acceptedrequests = Request.where(user_id: session[:current_user_id], status: 1, notification_type: 0)
    @rejectedrequests = Request.where(user_id: session[:current_user_id], status: 2, notification_type: 0)
  end

  def remove_notification
    @notification = Request.find(params[:id])
    @notification.destroy
    redirect_to (:back)
  end
end
