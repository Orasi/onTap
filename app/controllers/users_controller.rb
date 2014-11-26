class UsersController < ApplicationController
  def new
	   # @user = User.new
	   # puts login_params["username"]
  end

  def manage
    @users = User.all
  end

  def update
    user = User.find(params[:id])
    user.update(admin: params[:user][:admin])
    render json: user
  end
end
