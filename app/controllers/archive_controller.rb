class ArchiveController < ApplicationController
  before_action :require_admin, only: [:update, :destroy]

  def index
    # @events = Event.joins(:schedules).merge(Schedule.where('event_date < ?', DateTime.now.to_date))
    @events = Event.where("status = ? OR status = ?", 'finalized', 'closed')
    @events.sort! { |b, a| a.schedules.first.end <=> b.schedules.first.end }
  end
end
