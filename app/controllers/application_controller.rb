class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_expired_lab
  before_action :require_login
  before_action :get_profile
  helper_method :current_user
  before_action :require_admin, only: [:metrics]
  before_action :require_admin_or_host, only: [:send_email]
  around_filter :set_time_zone

  def send_email
    users=params[:users] == "all" ? User.all.pluck(:email) : Event.find(params[:users]).attendees_email
    UserEmail.user_email(users, params[:email][:subject], params[:email][:message])
    redirect_to :back, flash: { success: "Email sent to #{users.count} users." }
  end

  def host_request_email
    users=User.where(admin: true).pluck(:email)
    requester=User.find(session[:current_user_id])
    HostRequestMailer.host_request_mailer(users, "#{requester.display_name} would like to host an event", params[:email][:event_details])
    redirect_to :back, flash: { success: "Your request to host an event has been sent!" }
  end

  def lab_request_email
    users=User.where(admin: true).pluck(:email)
    requester=User.find(session[:current_user_id])
    HostRequestMailer.host_request_mailer(users, "#{requester.display_name} would like a lab added", params[:email][:event_details])
    redirect_to :back, flash: { success: "Your request to host an event has been sent!" }
  end

  def logs
    @dj_log = IO.readlines(Rails.root.to_s + '/log/delayed_job.log') if File.exist?(Rails.root.to_s + '/log/delayed_job.log')
    if @dj_log && @dj_log.length > 1000
      @dj_log = @dj_log[@dj_log.length-1000..@dj_log.length]
    end
    @prod_log = IO.readlines(Rails.root.to_s + '/log/production.log') if File.exist?(Rails.root.to_s + '/log/production.log')
    if  @prod_log && @prod_log.length > 1000
      @prod_log = @prod_log[@prod_log.length-1000..@prod_log.length]
    end
    @whenever_log = IO.readlines(Rails.root.to_s + '/log/whenever.log')  if File.exist?(Rails.root.to_s + '/log/whenever.log')
    if @whenever_log && @whenever_log.length > 1000
      @whenever_log = @whenever_log[@whenever_log.length-1000..@whenever_log.length]
    end
    @skytap_log = IO.readlines(Rails.root.to_s + '/log/skytap.log')  if File.exist?(Rails.root.to_s + '/log/skytap.log')
    if @skytap_log && @skytap_log.length > 1000
      @skytap_log = @skytap_log[@skytap_log.length-1000..@skytap_log.length]
    end
  end

  def metrics
    @events=Event.all
    @users=User.all
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

  def require_admin_or_host
    if current_user.nil? || !current_user.admin
      if params[:event].nil?
        redirect_to :calendar, flash: { error: 'You do not have the required permissions to access this area' }
      elsif !(Event.find(params[:event]).hosting_event?(current_user))
        redirect_to :calendar, flash: { error: 'You do not have the required permissions to access this area' }
      end
    end
  end

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = browser_timezone if browser_timezone.present?
    yield
  ensure
    Time.zone = old_time_zone 
  end

  def browser_timezone
    cookies["browser.timezone"]
  end
end
