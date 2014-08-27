class Survey < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  def self.create_survey_notification(user_id, event_id)
    @user = User.find(user_id)
    @event = Event.find(event_id)
    @notification = @event.notifications.create(user_id: @user.id, status: 'new', notification_type: 'survey')
    if @notification.save
    else
      errors.add(:event_id, 'Error saving survey notification')
    end
  end
end
