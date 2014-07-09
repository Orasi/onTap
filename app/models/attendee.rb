class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunchlearn
  validate :not_in_archive

  def not_in_archive
    if lunchlearn.lunch_date.past?
      if !user.check_if_admin?
        errors.add(:lunch_date, "#{lunchlearn.title} is already in the ")
      end
    end
  end
end
