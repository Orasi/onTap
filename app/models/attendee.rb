class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunchlearn
  validates :user_id, :lunchlearn_id, presence: true  
  validates :user_id, uniqueness: {scope: :lunchlearn_id} 
  validate :not_in_archive
  
  def not_in_archive
    return nil if user_id.blank? || lunchlearn_id.blank?
    if lunchlearn.lunch_date.past?
      if !user.check_if_admin?
        errors.add(:lunch_date, "#{lunchlearn.title} is already in the ")
      end
    end
  end
end
