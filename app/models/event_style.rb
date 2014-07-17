class EventStyle < ActiveRecord::Base
  belongs_to :event
  belongs_to :element, :polymorphic => true
end
