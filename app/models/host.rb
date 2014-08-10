class Host < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_presence_of :event_id
  validate :user_id_xor_external_and_host
  #still adds but eliminates duplicates
  validates :user, uniqueness: { scope: :event, message: "can only be listed as host once."}

  def user_id_xor_external_and_host
    if (external == false || external.blank?) && user_id.blank?
      errors.add(:user_id, "cannot be nil if not external hosst")
      return false
    elsif external && host.blank?
      errors.add(:host, "cannot be nil if external host")
      return false
    end
  end
end
