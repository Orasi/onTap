class Notification < ActiveRecord::Base
  belongs_to :event
  validates_inclusion_of :status, in: %w(new rejected approved)
  validates_inclusion_of :notification_type, in: %w(attendance survey)

  def self.notification_cleanup()
    @events=Event.all
    @events.each do |event|
      unless event.finalized_date.blank?
          if DateTime.now.to_date - 7.days >= event.finalized_date
            Notification.where(:event_id => event.id).destroy_all
          end
      end
    end
  end
end 
