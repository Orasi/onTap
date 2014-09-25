class Notification < ActiveRecord::Base
  belongs_to :event
  validates_inclusion_of :status, in: %w(new rejected approved)
  validates_inclusion_of :notification_type, in: %w(attendance survey)

  def self.notification_cleanup()
    @events=Event.all
    @events.each do |event|
      for 
        if DateTime.now.to_date - 7 >= Event.find(event_id).schedules.last.event_date.to_date
        Notification.destroy_all(:event_id==eventid)
        end
      end
    end
end 
