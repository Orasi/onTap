class Webinar < ActiveRecord::Base
  has_one :event_style, :as =>:element
  has_one :event, through: :event_style
end
