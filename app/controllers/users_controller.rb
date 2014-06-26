class UsersController < ApplicationController
  has_many :suggestions
  def new
	#@user = User.new
	#puts login_params["username"]
  end
end
