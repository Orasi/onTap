class EventsController < ApplicationController

  def calendar
#    @lunchlearns = Lunchlearnchlearns.where("lunch_date >= ?",DateTime.now.to_date).order(lunch_date: :asc)
     @events=Event.all
  end
 
end
