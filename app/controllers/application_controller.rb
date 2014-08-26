class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  helper_method :current_user

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def require_login
    if current_user.nil?
      redirect_to :login, flash: { error: 'You must be logged in to view onTap.' }
    end
  end

  def require_admin
    if current_user.nil? || !current_user.admin
      redirect_to :calendar, flash: { error: 'You do not have the required permissions to access this area' }
    end
  end
end
