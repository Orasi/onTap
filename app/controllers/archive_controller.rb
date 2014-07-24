class ArchiveController < ApplicationController
  before_action :require_admin, only: [:update, :destroy]

  def index
 #   @events = Event.includes(Schedule)
#    @events = Event.where(Event.schedules.first.lunch_date < DateTime.now.to_date).order(lunch_date: :desc)
     @events = Event.all
  end
  
  def show
    redirect_to show_event_path
  end  

  def edit
    redirect_to edit_event_path
  end

  def update
    redirect_to update_event_path
  end

  def destroy
    redirect_to destroy_event_path
    #redirect to archive here?
  end
end
