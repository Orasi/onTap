module ApplicationHelper
  def admin?
    unless session[:current_user_id].blank?
      User.find(session[:current_user_id]).admin
    end
  end

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning' }[flash_type] || flash_type.to_s
  end

  def display_picture(user_id)
    if User.find(user_id).photo
      image_tag User.find(user_id).photo, class: 'user-picture'
    else
      image_tag '/photos/blank.jpg', class: 'user-picture'
    end
  end

  def display_circle_picture(user_id)
    if User.find(user_id).photo
      image_tag User.find(user_id).photo, class: 'img-circle'
    else
      image_tag '/photos/blank.jpg', class: 'img-circle'
    end
  end
end
