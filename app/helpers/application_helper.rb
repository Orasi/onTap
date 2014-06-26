module ApplicationHelper
  def is_admin
    if not session[:current_user_id].blank?
      User.find(session[:current_user_id]).admin
    end
  end
end
