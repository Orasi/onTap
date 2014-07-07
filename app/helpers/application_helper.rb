module ApplicationHelper
  def is_admin
    if not session[:current_user_id].blank?
      User.find(session[:current_user_id]).admin
    end
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning"}[flash_type] || flash_type.to_s
  end
end
