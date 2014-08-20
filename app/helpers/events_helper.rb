module EventsHelper

  def get_flash_for_user
  flashmessage=""
    if User.find(session[:current_user_id]).check_if_admin?
      @requests=Request.where(notification_type: "attendance", status: ["new"])
      if @requests.count > 0
        @requests.each do |request|
    #      flashmessage="New attendance notifications!  #{link_to 'View ', user_notifications_path}<br />"
          flashmessage+="#{User.find(request.user_id).display_name} is requesting to attend the event #{Event.find(request.event_id).title}.  #{link_to 'Approve ', approve_attend_path( :id => request.id)}  #{link_to 'Reject', reject_attend_path( :id => request.id)}  #{link_to 'Details ', requests_path}<br />"
        end
      end
    end
      @requests=Request.where(user_id: session[:current_user_id], notification_type: "attendance", status: ["approved","rejected"])
      if @requests.count > 0
        @requests.each do |request|
          if (request.status == "approved")
            flashmessage+="#{User.find(request.manager_id).display_name} has approved your request to attend event #{Event.find(request.event_id).title}.  #{link_to 'Remove', request_path( :id => request.id), method: :delete}<br />"
          else
            flashmessage+="#{User.find(request.manager_id).display_name} has rejected your request to attend event #{Event.find(request.event_id).title}.  #{link_to 'Remove', request_path( :id => request.id), method: :delete}<br />"
          end
        end
      end
    
    @requests=Request.where(notification_type: "survey", status: ["new"], user_id: session[:current_user_id])
    if  @requests.count > 0
      @requests.each do |request|
        flashmessage+="You have a new survey to take. #{link_to 'Click here to take the survey now! ', new_survey_path}<br />"
      end
    end
    if !flashmessage.blank?
      flash.now[:success]=flashmessage.html_safe
    end
  end

  def check_for_requests
    Request.exists?(user_id: session[:current_user_id])
  end
end
