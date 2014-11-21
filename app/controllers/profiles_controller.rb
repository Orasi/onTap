class ProfilesController < ApplicationController
  before_action :require_owner, only: [:edit]
  before_action :require_owner_to_update, only: [:update]

  def edit
    @profile=User.find(params[:id]).profile
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update_attributes(profile_params)
    redirect_to :back, flash: { success: "Profile was updated" }
  end

  def profile_params
    params[:profile].permit(:food_pref, :location, :notification_settings, :other_food)
  end

  def require_owner
    if !(params[:id].to_i==current_user.id)
       redirect_to :calendar, flash: { error: 'You do not have permission to edit this profile' }
    end
  end

  def require_owner_to_update
    if !(params[:id].to_i==current_user.profile.id)
       redirect_to :calendar, flash: { error: 'You do not have permission to update this profile' }
    end
  end
end
