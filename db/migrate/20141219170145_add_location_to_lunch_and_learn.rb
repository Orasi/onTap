class AddLocationToLunchAndLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :location, :string
  end
end
