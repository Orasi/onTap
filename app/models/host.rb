class Host < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validate :user_id_xor_external_and_host
  #still adds but eliminates duplicates
  #validates :user, uniqueness: { scope: :event, message: "can only be listed as host once."}

  def user_id_xor_external_and_host
    if external == false && user_id.blank?
      error.add(:base, "If External Host is false a user id must be provided")
    elsif external && host.blank?
      error.add(:base, "If External host is true a host must be provided")
    end
  end
end
