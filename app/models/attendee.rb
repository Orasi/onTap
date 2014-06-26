class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunchlearn
end
