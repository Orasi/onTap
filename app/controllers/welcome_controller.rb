class WelcomeController < ApplicationController
  skip_before_action :require_login, only:[:validate, :login]
  
  def login
    unless session[:current_user_id].blank?
      redirect_to :calendar
    end
  end
  
  def validate
    @user = User.find_or_create(params[:login][:username].downcase)
    unless @user.validate_against_ad(params[:login][:password])
      redirect_to :login, flash: {error: "Invalid username or password"}
      return
    end
    
    if @user.save
	session[:current_user_id] = @user.id
	Session.create(session_id: session[:session_id])
        redirect_to :calendar
    else
	redirect_to :login, flash: {error: "Unknown Error"}
	#TODO: User Validation errors reporting
    end	
   
  end

  def logout
    @_current_user = session[:current_user_id] = nil
    redirect_to :login, flash: {error:  "Logged Out"}
  end 

  private

  def login_params
    params.require(:login).permit(:username, :password, :photo, :email)
  end

end
