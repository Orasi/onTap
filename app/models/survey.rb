class Survey < ActiveRecord::Base
  belongs_to :event

  def create_survey_notification(user_id, event_id)
    @user=User.find(user_id)
    @event=Event.find(event_id)
    @survey=@event.create(user_id: session[:current_user_id], status: 0, notification_type: 1)
    if @request.save
      flash[:success] = "A request to take a survey for event: #{Event.find(event_id).title} has been sent to #{User.find(user_id).title}"      
    else
      flash[:error] = "Error saving survey request"
    end
  end
end
