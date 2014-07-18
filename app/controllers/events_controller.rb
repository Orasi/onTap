class EventsController < ApplicationController

  def calendar
#    @lunchlearns = Lunchlearnchlearns.where("lunch_date >= ?",DateTime.now.to_date).order(lunch_date: :asc)
  #   @events=Event.where(lunch_date >= DateTime.now.to_date).order(lunch_date :asc)
    # @schedules = Schedule.where("lunch_date >= ?",DateTime.now.to_date).order(lunch_date: :asc)
   # @events=Event.joins(:schedules).where(schedules.lunch_date >= DateTime.now.to_date).order(lunch_date: :asc)
    # @events=Event.include(:schedules).where({schedules:  lunch_date >= DateTime.now.to_date  }).order(lunch_date: :asc)
     @events=Event.joins(:schedules).merge(Schedule.where(:lunch_date >= DateTime.now.to_date))
  end
 
end
