module EventsHelper

  def get_flash_for_user
    @requests=Request.where(user_id: session[:current_user_id])
#    @requests.each do |request|
#    flash.now[:success] = "#{User.find(request.user_id).display_name} is requesting to attend event: #{Event.find(request.event_id).title}"
#    end
    if @requests.exists?(notification_type: 0)
      flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}\n"
#      flashmessage="New attendance notifications!  #{link_to 'View ', :onclick => "render :partial => '_attendance_notifications'"}\n"
#render partial: 'eventJumbo'
    end
    if @requests.exists?(notification_type: 1)
      flashmessage="New survey!\n"
    end
    flash.now[:success]=flashmessage.html_safe
  end

  def check_for_requests
    Request.exists?(user_id: session[:current_user_id])
  end
# link_to 'Add Tester', :onclick => "render :partial => 'somepartial'
end
