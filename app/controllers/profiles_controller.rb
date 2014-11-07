class ProfilesController < ApplicationController
  #show the profile to the user
  def show
    @profile=User.find(params[:id]).profile
  end
  #create a default profile

  def edit
    @profile=User.find(params[:id]).profile
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update_attributes(profile_params)
    redirect_to profile_path(@profile), flash: { success: "Profile was updated" }
  end

  def destroy
  end


  def profile_params
    params[:profile].permit(:food_pref, :location, :notification_settings, :other_food)
  end


end
