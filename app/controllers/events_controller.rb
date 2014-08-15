class EventsController < ApplicationController
  before_action :require_admin_or_host, only: [:new, :edit, :destroy]
  def calendar
     @events=Event.joins(:schedules).merge(Schedule.where("event_date >= ?",DateTime.now.to_date))
     @events.sort! { |a,b| a.schedules.first.event_date <=> b.schedules.first.event_date }
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

    @event=Event.new(event_params)
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
      @eventtype = Lunchlearn.new(lunchlearn_params)
    elsif params[:event][:event_style] == 'webinar'
      @eventtype = Webinar.new(webinar_params)
     
    end

    unless @eventtype.save
       @event.destroy
       redirect_to :calendar, flash: {error: "Event \"#{params[:event][:title]}\" was not created"}
       return
    end

    if params[:event][:host]
      @event.hosts.create(external: true, host: params[:event][:host])
    elsif !params[:event][:hosts].nil?
      params[:event][:hosts].each do |host|
        @event.hosts.create(user_id: host)
      end
    end

    @eventstyle=@event.build_event_style(:element => @eventtype)
    if  @eventstyle.save 
      redirect_to :calendar, flash: {success: "Event \"#{@event.title}\" was created"}
    else
      redirect_to :calendar, flash: {error: "Event \"#{@event.title}\" was not created"}
    end
  end

  def edit
    #temp for testing surveys

    Survey.create_survey_notification(current_user.id, params[:id])
     #end temp for testing surveys
    @event = Event.find(params[:id])
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
    
    @event.schedules.each do |s|
      s.destroy
    end
    @schedule=@event.schedules.new(schedule_params)
    unless @schedule.save
      @event.destroy
      redirect_to :calendar, flash: {error: "Event \"#{params[:event][:title]}\" was not created"}
      return
    end

    if params[:event][:event_style] == 'lunch_and_learn'
      @event_type = Lunchlearn.find_by(id: @event_style.element_id)
      @event_type.update_attributes(lunchlearn_params)
    elsif params[:event][:event_style] == 'webinar'
      @event_type = Webinar.find_by(id: @event_style.element_id)
      @event_type.update_attributes(webinar_params)
      @event.hosts.each {|host| host.destroy}
      @event.hosts.create(external: true, host: params[:event][:host])
    elsif params[:event][:event_style] == 'training_class'
    end


    redirect_to event_path(@event), flash: {success: "Event \"#{@event.title}\" was updated"}
  end
  
  def destroy
    oldEventTitle=Event.find(params[:id]).title
    #add additional cleanup
    Event.find(params[:id]).destroy
    redirect_to :calendar, flash: {error: "Event \"#{oldEventTitle}\" was deleted"}
  end
  private

  def require_admin_or_host
    if params[:id]
      redirect_to :calendar, flash: {error: "You do not have the required permission to edit this content"} unless current_user.admin || Event.find(params[:id]).hosting_event?(current_user)
    else
      redirect_to :calendar, flash: {error: "You do not have the required permission to edit this content"} unless current_user.admin
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :restricted)
  end

  def schedule_params
    params.require(:event).permit(:event_date, :end_time, :event_time)
  end
 
  def lunchlearn_params
    params[:event].permit(:has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url)
  end

  def webinar_params
    params[:event].permit(:url)
  end

end
