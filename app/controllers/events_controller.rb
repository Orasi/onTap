class EventsController < ApplicationController

  def calendar
     @events=Event.joins(:schedules).merge(Schedule.where("event_date >= ?",DateTime.now.to_date))
  end

  def show
    @event = Event.find(params[:id])
  end  

  def new
    @event = Event.new
    @schedule = @event.schedules.new
  end

  def create
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/%Y")

    @event=Event.new
    unless @event.save
      redirect_to :calendar, flash: {error: "Event \"#{params[:event][:title]}\" was not created"}
      return
    end

    @schedule=@event.schedules.new(schedule_params)
    unless @schedule.save
      @event.destroy
      redirect_to :calendar, flash: {error: "Event \"#{params[:event][:title]}\" was not created"}
      return
    end

    if params[:event][:event_style] == 'lunch_and_learn'
      @eventtype=Lunchlearn.new(lunchlearn_params)
    end
    
    params[:event][:hosts].each do |host|
      @event.hosts.create(user_id: host)
    end

    @eventstyle=@event.build_event_style(:element => @eventtype)
    if  @eventstyle.save 
      redirect_to :calendar, flash: {success: "Event \"#{@event.title}\" was created"}
    else
      redirect_to :calendar, flash: {error: "Event \"#{@event.title}\" was not created"}
    end
  end

  def edit
    @event = Event.find(params[:id])
    @eventtype=Lunchlearn.find(@event.event_style.element.id)
    render :new
  end

  def update
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/%Y")
    #need better way to find event
    @event = Event.find(params[:id])
    @event_style = EventStyle.find_by(event_id: @event.id)

    @event.hosts.each {|host| host.destroy} 
    unless params[:event][:hosts].nil?
      params[:event][:hosts].each do |host|
        @event.hosts.create(user_id: host)
      end
    end
    
    if params[:event][:event_style] == 'lunch_and_learn'
      @event_type = Lunchlearn.find_by(id: @event_style.element_id)
      @event_type.update_attributes(lunchlearn_params)
    end

    redirect_to event_path(@event), flash: {success: "Event \"#{@event.event_style.element.title}\" was updated"}
  end

  private

  def schedule_params
    params.require(:event).permit(:event_date, :end_time, :event_time)
  end
 
  def lunchlearn_params
    params[:event].permit(:title, :description, :has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url)
  end

end
