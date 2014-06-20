module ApplicationHelper
  def is_admin
    User.find(session[:current_user_id]).admin
  end
end
