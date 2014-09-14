class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates_presence_of :user_id, :event_id
  validates_uniqueness_of :user_id,  scope: :event_id
  validate :not_in_archive

  def not_in_archive
    if event
      if event.status === 'finalized'
        unless user.check_if_admin?
          errors.add(:event_date, "#{event.title} is already in the archive")
        end
      end
    else
      errors.add(:event_id, 'Attendee must have event id')
    end
  end
end
