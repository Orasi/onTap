module EventsHelper

  def get_flash_for_user

    if User.find(session[:current_user_id]).check_if_admin?
      @requests=Request.where(notification_type: 0, status: [0])
      if @requests.count > 0
        flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}\n"
      end
    else
      @requests=Request.where(user_id: session[:current_user_id])
      if @requests.exists?(notification_type: 0, status: [1,2])
        flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}\n"
      end
    end
    if @requests.exists?(notification_type: 1)
#need to concat string
      flashmessage="New survey!\n"
    end
    if !flashmessage.nil?
      flash.now[:success]=flashmessage.html_safe
    end
  end

  def check_for_requests
    Request.exists?(user_id: session[:current_user_id])
  end
end
