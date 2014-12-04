class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_expired_lab
  before_action :require_login
  before_action :get_profile
  helper_method :current_user
  before_action :require_admin, only: [:send_email]

  def send_email
    users = params[:users] == 'all' ? User.all.pluck(:email) : params[:users]
    UserEmail.user_email(users, params[:email][:subject], params[:email][:message]).deliver
    redirect_to :back, flash: { success: "Email sent to #{users.split.count} users."}
  end

  def logs

    @dj_log = IO.readlines(Rails.root.to_s + "/log/delayed_job.log")[-1000..-1] if File.exist?(Rails.root.to_s + "/log/delayed_job.log")
    @prod_log = IO.readlines(Rails.root.to_s + "/log/production.log")[-1000..-1] if File.exist?(Rails.root.to_s + "/log/production.log")
    @whenever_log = IO.readlines(Rails.root.to_s + "/log/whenever.log")[-1000..-1]  if File.exist?(Rails.root.to_s + "/log/whenever.log")
  end

  def get_profile
    @profile = current_user.profile if current_user
  end

  def check_expired_lab
    unless current_user.nil? || current_user.environment.nil? || current_user.environment.expiration.nil?
      if current_user.environment.expiration.to_datetime < DateTime.now.utc
        json = current_user.environment.get_details
        unless json['error'].blank?
          puts '**************************** ERROR ******************************************'
          puts json['error']
          puts '*****************************************************************************'
          current_user.environment.destroy
        end
      end
    end
  end

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end
  
  def store_location
    session[:return_to] = if request.get?
      request.original_url
    else
      request.referer
    end
  end

  def require_login
    if current_user.nil?
      store_location
      redirect_to :login
    end
  end

  def require_admin
    if current_user.nil? || !current_user.admin
      redirect_to :calendar, flash: { error: 'You do not have the required permissions to access this area' }
    end
  end
end
