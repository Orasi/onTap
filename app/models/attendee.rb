class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  #validate :not_in_archive
  validates_presence_of :user_id, :event_id
  validates_uniqueness_of :user_id,  scope: :event_id

  def not_in_archive
    if event && event.schedules.first.event_date.past?
      unless user.check_if_admin?
        errors.add(:event_date, "#{event.title} is already in the archive")
      end
    end
  end
end
