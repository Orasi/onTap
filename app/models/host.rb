class Host < ActiveRecord::Base
  belongs_to :lunchlearn
  belongs_to :user
  validates :user_id, :lunchlearn_id, presence: true
  #still adds but eliminates duplicates
  validates :user_id, uniqueness: { scope: :lunchlearn_id, message: "can only be listed as host once."}
end
