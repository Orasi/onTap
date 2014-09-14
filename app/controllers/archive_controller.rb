class ArchiveController < ApplicationController
  before_action :require_admin, only: [:update, :destroy]

  def index
    # @events = Event.joins(:schedules).merge(Schedule.where('event_date < ?', DateTime.now.to_date))
    @events = Event.where(status: :finalized)
    @events.sort! { |a, b| a.schedules.first.event_date <=> b.schedules.first.event_date }
  end
end
