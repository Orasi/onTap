class ArchiveController < ApplicationController
  before_action :require_admin, only: [:update, :destroy]

  def index
    @events = Event.joins(:schedules).merge(Schedule.where('event_date < ?', DateTime.now.to_date))
    @events.sort! { |a, b| a.schedules.first.event_date <=> b.schedules.first.event_date }
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
    # redirect to archive here?
  end
end
