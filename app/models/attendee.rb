class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validate :not_in_archive

  def not_in_archive
    if event.schedules.first.lunch_date.past?
      if !user.check_if_admin?
        errors.add(:lunch_date, "#{lunchlearn.title} is already in the archive")
      end
    end
  end
end
