class EventStyle < ActiveRecord::Base
  belongs_to :event
  belongs_to :element, :polymorphic => true

  def display_name
    if element_type == "Lunchlearn"
      "lunch_and_learn"
    end
  end
end
