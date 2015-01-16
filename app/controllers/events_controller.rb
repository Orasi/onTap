class EventsController < ApplicationController
  before_action :require_admin_or_host, only: [:new, :edit, :destroy, :update, :create, :finalize]
  before_action :require_past, only: [:finalize]

  def send_invite
    @event = Event.find(params[:id])
    CalendarInvite.invitation_email(@event, current_user).deliver
    render json: @event
  end
  def calendar
    # @events = Event.joins(:schedules).merge(Schedule.where('event_date >= ?', DateTime.now.to_date))
    @events = Event.where(status: nil)
    @events.delete_if { |event| !event.can_view_event?(current_user.id) && !event.hosting_or_above?(current_user) }
    @events.sort! { |a, b| a.schedules.first.start <=> b.schedules.first.start }
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @schedules = @event.schedules.new
    @labs = Template.all
    @margin = 25
  end

  def create
    if params[:event][:schedules_attributes].nil?
      redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not created. Must have at least one day scheduled"}
      return
    end

    @event = Event.new(event_params)
    @event.visible_to_departments=params[:event][:visible_to_departments]
    #not sure why department approvals not being picked up as part of event_params
    @event.department_approvals=params[:event][:department_approvals]
    unless @event.save
      redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not created" }
      return
    end

    params[:event][:schedules_attributes].each do |key, value|
      if (!value[:event_date].nil? && !value[:end].nil? && !value[:start].nil?)
        e_date = value[:event_date] = DateTime.strptime(value[:event_date], '%m/%d/%Y').to_date
        e_start = Time.parse(value[:start])
        e_end = Time.parse(value[:end])
        e_start = DateTime.new(e_date.year, e_date.month, e_date.day, e_start.hour, e_start.min, e_start.sec, '-' + (value[:time_zone_offset].to_i / 60).to_s)
        e_end = DateTime.new(e_date.year, e_date.month, e_date.day, e_end.hour, e_end.min, e_end.sec, '-' + (value[:time_zone_offset].to_i / 60).to_s)
        @schedule = @event.schedules.new(start: e_start, end: e_end)
        unless @schedule.save
          @event.destroy
          redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not created.   Error: " + @schedule.errors.full_messages.join }
          return
        end
      end
    end

    #Add Lab
    if params[:add_lab]
      @event.update(lab_id: params[:event][:lab_id])
    end

    if !params[:event][:hosts].nil?
      params[:event][:hosts].each do |host|
        @event.hosts.create(user_id: host)
      end
    end

    if params[:event][:event_style] == 'lunch_and_learn'
      @eventtype = Lunchlearn.new(lunchlearn_params)
    elsif params[:event][:event_style] == 'webinar'
      @eventtype = Webinar.new(webinar_params)
      @event.hosts.each(&:destroy)
      @event.hosts.create(external: true, host: params[:event][:host])
    elsif params[:event][:event_style] == 'training_class'
      @eventtype = TrainingClass.new(trainingclass_params)
    end

    unless @eventtype.save
      @event.destroy
      redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not created.  Error: " + @eventtype.errors.full_messages.join }
      return
    end


    @eventstyle = @event.build_event_style(element: @eventtype)
    if  @eventstyle.save
      redirect_to :calendar, flash: { success: "Event \"#{@event.title}\" was created" }
    else
      redirect_to :calendar, flash: { error: "Event \"#{@event.title}\" was not created.  Error: " + @eventstyle.errors.full_messages.join }
    end
  end

  def edit
    # temp for testing surveys

    #  Survey.create_survey_notification(current_user.id, params[:id])
    # end temp for testing surveys
    @event = Event.find(params[:id])
    @schedules = @event.schedules
    @labs = Template.all
    @margin = 25
    render :new
  end

  def update
    if params[:event][:schedules_attributes].nil?
      redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not created. Must have at least one day scheduled"}
      return
    end

    @event = Event.find(params[:id])

    @event.schedules.each(&:destroy)
    params[:event][:schedules_attributes].each do |key, value|
      if (!value[:event_date].nil? && !value[:end].nil? && !value[:start].nil?)
        e_date = Date.strptime(value[:event_date], '%m/%d/%Y')
        e_start = Time.parse(value[:start])
        e_end = Time.parse(value[:end])
        e_start = DateTime.new(e_date.year, e_date.month, e_date.day, e_start.hour, e_start.min, e_start.sec, '-' + (value[:time_zone_offset].to_i / 60).to_s)
        e_end = DateTime.new(e_date.year, e_date.month, e_date.day, e_end.hour, e_end.min, e_end.sec, '-' + (value[:time_zone_offset].to_i / 60).to_s)
        @schedule = @event.schedules.new(start: e_start, end: e_end)
        unless @schedule.save
          @event.destroy
          redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not updated.  Error: " + @schedle.errors.full_messages.join }
          return
        end
      end
    end

    @event_style = EventStyle.find_by(event_id: @event.id)

    if params[:add_lab]
      @event.update(lab_id: params[:event][:lab_id])
    else
      @event.update(lab_id: nil)
    end

        @event.hosts.each(&:destroy)
    unless params[:event][:hosts].nil?
      params[:event][:hosts].each do |host|
        @event.hosts.create(user_id: host)
      end
    end


    if params[:event][:event_style] == 'lunch_and_learn'
      @event_type = Lunchlearn.find_by(id: @event_style.element_id)
      @event_type.update_attributes(lunchlearn_params)
    elsif params[:event][:event_style] == 'webinar'
      @event_type = Webinar.find_by(id: @event_style.element_id)
      @event_type.update_attributes(webinar_params)
      @event.hosts.each(&:destroy)
      @event.hosts.create(external: true, host: params[:event][:host])
    elsif params[:event][:event_style] == 'training_class'
      @event_type = TrainingClass.find_by(id: @event_style.element_id)
      @event_type.update_attributes(trainingclass_params)
    end

    unless @event.update_attributes(event_params)
      redirect_to :calendar, flash: { error: "Event \"#{params[:event][:title]}\" was not updated.  Error: " + @event.errors.full_messages.join }
      return
    end
    @event.update(visible_to_departments: params[:event][:visible_to_departments])
    #not sure why department approvals not being picked up as part of event_params
    @event.update(department_approvals: params[:event][:department_approvals])
    if params[:send_email]=="Yes"
      @event.update_attendees_email()
    end
    redirect_to event_path(@event), flash: { success: "Event \"#{@event.title}\" was updated" }
  end

  def destroy
    oldEventTitle = Event.find(params[:id]).title
    # add additional cleanup
    Event.find(params[:id]).destroy
    redirect_to :calendar, flash: { error: "Event \"#{oldEventTitle}\" was deleted" }
  end

  def finalize
    @event = Event.find(params[:id])
    if @event.event_style.element.class::ATTENDABLE
      @attended = JSON.parse(params[:user_data])['attended']
      @not_attended = JSON.parse(params[:user_data])['not_attended']
      Attendee.where(user_id: @attended, event_id: params[:id]).each do |attendee|
        attendee.update!(status: 'attended')
        Survey.create_survey_notification(attendee.user_id, @event.id)
      end
      Attendee.where(user_id: @not_attended, event_id: params[:id]).each do |attendee|
        attendee.update!(status: 'noshow')
      end
    end
    @event.update!(status: :finalized)
    @event.update!(finalized_date: DateTime.now.to_date)
    SurveyMailer.survey_mailer(@event).deliver
    redirect_to event_path(@event), flash: { success: "Event \"#{@event.title}\" was finalized" }
  end

  private

  def require_admin_or_host
    if params[:id]
      redirect_to :calendar, flash: { error: 'You do not have the required permission to edit this content' } unless current_user.admin || Event.find(params[:id]).hosting_event?(current_user)
    else
      redirect_to :calendar, flash: { error: 'You do not have the required permission to edit this content' } unless current_user.admin
    end
  end

  def require_past
    unless Event.find(params[:id]).past?
      redirect_to :calendar, flash: { error: 'Events can not be finalized before they end.' }
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :restricted, :department_approvals, :limited_visibility, :visible_to_departments))
  end

  def schedule_params
    params[:event][:schedules_attributes].permit(:event_date, :end, :start)
  end

  def lunchlearn_params
    params[:event].permit(:has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url, :location)
  end

  def trainingclass_params
    params[:event].permit(:has_GoToMeeting, :meeting_phone_number, :access_code, :go_to_meeting_url, :location)
  end

  def webinar_params
    params[:event].permit(:url)
  end
end
