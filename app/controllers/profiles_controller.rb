class ProfilesController < ApplicationController
  #show the profile to the user
  def show
    @profile=User.find(params[:id]).profile
  end
  #create a default profile
  def new
    @profile=User.find(params[:id]).profile.new(food_pref: "Not Set", location: "Not Set", notification_settings: "Not Set")
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
