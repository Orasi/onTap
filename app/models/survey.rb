class Survey < ActiveRecord::Base
  belongs_to :event

  def self.create_survey_notification(user_id, event_id)
    @user = User.find(user_id)
    @event = Event.find(event_id)
    @request = @event.requests.create(user_id: @user.id, status: 'new', notification_type: 'survey')
    if @request.save
    else
      errors.add(:event_id, 'Error saving survey request')
    end
  end
end
