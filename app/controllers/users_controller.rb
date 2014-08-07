class UsersController < ApplicationController
  def new
	#@user = User.new
	#puts login_params["username"]
  end

  def notifications
    @notifications=Request.where(user_id: session[:current_user_id], notification_type: 0)
  end

end
