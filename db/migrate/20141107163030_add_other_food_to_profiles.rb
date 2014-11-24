class AddOtherFoodToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :other_food, :string
  end
end
