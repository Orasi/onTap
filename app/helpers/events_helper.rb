module EventsHelper

  def get_requests_for_user
    @requests=Requests.where(user_id: session[:current_user_id])
    @requests.each do |request|
    flash.now 
  end

  def check_for_requests
    Request.exists?(user_id: session[:current_user_id])
  end

end
