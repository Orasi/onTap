class WelcomeController < ApplicationController
  skip_before_action :require_login, only:[:validate, :login]
  
  def login
    if not session[:current_user_id].blank?
      redirect_to :calendar
    end
  end
  
  def validate
    if validate_against_ad(login_params["username"], login_params["password"])     
        user_exist(login_params["username"])
	
	#Validates the user is valid.  If valid set the Session id
	if @User.save
		session[:current_user_id] = @User.id
		Session.create(session_id: session[:session_id])
                  redirect_to :calendar
    	else
		redirect_to :login
		#TODO: User Validation error reporting
    	end	
    else
      redirect_to :login, flash: {error: "Invalid username or password."}
    end
  end
  def logout
    @_current_user = session[:current_user_id] = nil
    redirect_to :login, flash: {error:  "Logged Out"}
  end 
  private

  #Checks if the user already exist in the system. If not, creates a entry in the Users database
  #Returns a reference to the user
  def user_exist(username)
	username.downcase!	
	if User.exists?(:username => username)
	  @User = User.find_by(username: username)
	else
	  name=username.split('.')
	  @User=User.new(username: username, first_name: name.first, last_name: name.last, admin: false)
	end
  end

  def validate_against_ad(username, password)
    #Do authentication against the AD.
    return false if password.blank?
    return true unless Rails.env.production?

    ldap = Net::LDAP.new :host => '10.238.242.32',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "ORASI\\#{username}",
      :password => password
    }
    return ldap.bind
  end

  def login_params
    params.require(:login).permit(:username, :password)
  end
end
