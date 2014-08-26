class Host < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_presence_of :event_id
  validate :user_id_xor_external_and_host
  # still adds but eliminates duplicates
  validates :user, uniqueness: { scope: :event, message: 'can only be listed as host once.' } unless :external

  def user_id_xor_external_and_host
    unless (host.blank? && external.blank?) ^ user_id.blank?
      errors.add(:user_id, 'cannot be nil if not external hosst')
      return false
    end
  end
end
