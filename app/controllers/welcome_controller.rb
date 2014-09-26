class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [:validate, :login]

  def login
    if current_user
      redirect_to :calendar
    end
  end

  def validate
    if params[:login][:username].blank? || params[:login][:password].blank?
      redirect_to :login, flash: { error: 'Invalid username or password' }
      return
    end
    @user = User.find_or_create(params[:login][:username].downcase)
    unless @user.validate_against_ad(params[:login][:password])
      redirect_to :login, flash: { error: 'Invalid username or password' }
      return
    end

    if @user.save
	     session[:current_user_id] = @user.id
	     Session.create(session_id: session[:session_id])
      if session[:return_to]
        url = session[:return_to]
        session[:return_to] = nil
        redirect_to url
      else
        redirect_to :calendar
      end
      
    else
	     redirect_to :login, flash: { error: 'Unknown Error' }
	     # TODO: User Validation errors reporting
    end
  end

  def logout
    @_current_user = session[:current_user_id] = nil
    redirect_to :login, flash: { error:  'Logged Out' }
  end
end
