class TrainingClass < ActiveRecord::Base
  has_many :attachments
  has_one :event_style, :as =>:element
  has_one :event, :through => :event_styles

  VIEWS = ['Jumbo', 'GoToMeeting', 'Attachments', 'Attendees']
  ATTENDABLE = true
end
