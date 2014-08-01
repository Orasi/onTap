class EventStyle < ActiveRecord::Base
  belongs_to :event
  belongs_to :element, :polymorphic => true

  def display_name
    if element_type == "Lunchlearn"
      "lunch_and_learn"
    elsif element_type == "Webinar"
      "webinar"
    elsif element_type == "TrainingClass"
      "training_class"
    end
  end
end
