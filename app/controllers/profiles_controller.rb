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
  end

  def destroy
  end

end
