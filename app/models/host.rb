class Host < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  #still adds but eliminates duplicates
  validates :user, uniqueness: { scope: :event, message: "can only be listed as host once."}
end
