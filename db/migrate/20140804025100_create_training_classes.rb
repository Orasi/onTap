class CreateTrainingClasses < ActiveRecord::Migration
  def change
    create_table :training_classes do |t|

      t.timestamps
    end
  end
end
