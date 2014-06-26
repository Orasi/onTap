class Host < ActiveRecord::Base
  belongs_to :lunchlearn
  belongs_to :user
  
  #still adds but eliminates duplicates
  validates :user, uniqueness: { scope: :lunchlearn, message: "can only be listed as host once."}
end
