class LunchlearnsController < ApplicationController
  before_action :require_admin, only: [:new, :destroy]
  after_action :add_hosts, only: [:create]
  after_action :update_hosts, only: [:update]
  before_action :require_admin_or_host, only: [:update]
  before_action :temp_admin_or_host_ugly, only: [:edit]

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @schedule = @event.schedules.new
    @lunchlearn = Lunchlearn.new
  end

  def create
    params[:lunchlearn][:lunch_date] = DateTime.strptime(params[:lunchlearn][:lunch_date], '%m/%d/%Y')
    @event = Event.create
    @schedule = @event.schedules.create(schedule_params)
    @lunch = Lunchlearn.new(lunchlearn_params)
    @eventstyle = @event.build_event_style(element: @lunch)
    @eventstyle.save
    if @lunch.save
      redirect_to :calendar, flash: { success: "Event \"#{@lunch.title}\" was created" }
    else
      redirect_to :calendar, flash: { error: "Event \"#{@lunch.title}\" was not created" }
    end
  end

  def edit
    @event = Event.find(params[:id])
    @lunchlearn = Lunchlearn.find(@event.event_style.element.id)
    render :new
  end

  def update
    params[:lunchlearn][:lunch_date] = DateTime.strptime(params[:lunchlearn][:lunch_date], '%m/%d/%Y')
    # need better way to find event
    @lunch = Lunchlearn.find(params[:id])
    @eventstyle = EventStyle.find_by(element_id: @lunch.id)
    @event = Event.find_by(id: @eventstyle.event_id)
    @lunch.update_attributes(lunchlearn_params)
    @lunch.save
    redirect_to lunchlearn_path(@event), flash: { success: "Event \"#{@lunch.title}\" was updated" }
  end

  def destroy
    oldEventTitle = Event.find(params[:id]).event_style.element.title
    # add additional cleanup
    Event.find(params[:id]).destroy
    redirect_to :calendar, flash: { error: "Event \"#{oldEventTitle}\" was deleted" }
  end
  private

  def lunchlearn_params
    params[:lunchlearn].permit(:title, :description, :has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url)
  end

  def lunch_host_ids
    if !params[:event].nil?
      params.require(:event).permit(hosts: [])
    else
      params.permit(hosts: [])
    end
  end

  def schedule_params
    params.require(:lunchlearn).permit(:lunch_date, :end_time, :lunch_time)
  end

  def add_hosts
    unless lunch_host_ids[:hosts].blank?
      lunch_host_ids[:hosts].each do |host_id|
        Host.create(event: @event, user: User.find(host_id))
      end
    end
  end

  # add_host can just use this
  def update_hosts
    Host.where(event: @event).delete_all
    unless lunch_host_ids[:hosts].blank?
      lunch_host_ids[:hosts].each do |host_id|
        Host.create(event: @event, user: User.find(host_id))
      end
    end
  end

  # combine with require admin or host
  def temp_admin_or_host_ugly
    @event = Event.find(params[:id])
    if@event.is_hosting_event(current_user) && !current_user.admin
      redirect_to :calendar, flash: { error: 'You must be an admin or host of the event to edit it' }
    end
  end

  def require_admin_or_host
    # need better way to find event
    @lunch = Lunchlearn.find(params[:id])
    @eventstyle = EventStyle.find_by(element_id: @lunch.id)
    @event = Event.find_by(id: @eventstyle.event_id)
    if !@event.is_hosting_event(current_user) && !current_user.admin
      redirect_to :calendar, flash: { error: 'You must be an admin or host of the event to edit it' }
    end
  end
end
