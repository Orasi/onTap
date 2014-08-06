class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validate :not_in_archive
  
  def not_in_archive
    if event.schedules.first.event_date.past?
      unless user.check_if_admin?
        errors.add(:event_date, "#{event.title} is already in the archive")
      end
    end
  end
end
