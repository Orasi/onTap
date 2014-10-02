class Notification < ActiveRecord::Base
  belongs_to :event
  validates_inclusion_of :status, in: %w(new rejected approved)
  validates_inclusion_of :notification_type, in: %w(attendance survey)

  def self.notification_cleanup()
    @events=Event.where(status: 'finalized')
    @events.each do |event|
      unless event.finalized_date.blank?
          if DateTime.now.to_date - 7.days >= event.finalized_date
            Notification.where(:event_id => event.id).destroy_all
            event.update_attribute(:status, 'closed')
            SurveyEndMailer.survey_end_mailer(event).deliver
          end
      end
    end
  end
end 
