class AddMissingStuffToTrainingClasses < ActiveRecord::Migration
  def change
    add_column :training_classes, :location, :text
  end
end
