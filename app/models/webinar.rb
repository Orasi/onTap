class Webinar < ActiveRecord::Base
  has_many :attachments
  has_one :event_style, as: :element
  has_one :event, through: :event_styles

  VIEWS = %w(Jumbo Finalize Webinar Attachments)

  validates_presence_of :url
  ATTENDABLE = false
end
