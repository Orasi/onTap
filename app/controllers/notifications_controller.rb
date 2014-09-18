class NotificationsController < ApplicationController
  before_action :survey_complete, only: [:destroy]
  before_action :admin_or_owner, only: [:destroy]

  def index
    # will need to add on restriction here when managers table added
    @notifications = Notification.where(notification_type: 'attendance', status: 'new')
    @acceptedrequests = Notification.where(user_id: session[:current_user_id], status: 'approved', notification_type: 'attendance')
    @rejectedrequests = Notification.where(user_id: session[:current_user_id], status: 'rejected', notification_type: 'attendance')
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to (:back)
  end

  private 

  def survey_complete

    if Survey.where(user_id: Notification.find(params[:id]).user_id, event_id: Notification.find(params[:id]).event_id).blank? && Notification.find(params[:id]).notification_type == "survey"
      redirect_to :calendar, flash: { error: 'Survey must be completed before notification may be removed' }      
    end
  end

  def admin_or_owner
    if session[:current_user_id] != Notification.find(params[:id]).user_id && !User.find(Notification.find(params[:id]).user_id).check_if_admin?
      redirect_to :calendar, flash: { error: 'Must be notification owner or admin to remove notification' }  
    end
  end
end
