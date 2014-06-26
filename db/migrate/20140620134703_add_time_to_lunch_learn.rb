class AddTimeToLunchLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :lunch_time, :time
  end
end
