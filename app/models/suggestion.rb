class Suggestion < ActiveRecord::Base
  belongs_to :user
  validates :suggestion_title, :suggestion_description, presence: true
end
