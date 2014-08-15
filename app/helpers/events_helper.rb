module EventsHelper

  def get_flash_for_user

    if User.find(session[:current_user_id]).check_if_admin?
      @requests=Request.where(notification_type: 0, status: [0])
      if @requests.count > 0
        flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}<br />"
      end
    else
      @requests=Request.where(user_id: session[:current_user_id])
      if @requests.exists?(notification_type: 0, status: [1,2])
        flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}<br />"
      end
    end
    @requests=Request.where(notification_type: 1, status: [0], user_id: session[:current_user_id])
    if  @requests.count > 0
      @requests.each do |request|
        flashmessage+="You have a new survey to take. #{link_to 'Click here to take the survey now! ', new_survey_path}<br />"
      end
    end
    if !flashmessage.nil?
      flash.now[:success]=flashmessage.html_safe
    end
  end

  def check_for_requests
    Request.exists?(user_id: session[:current_user_id])
  end
end
