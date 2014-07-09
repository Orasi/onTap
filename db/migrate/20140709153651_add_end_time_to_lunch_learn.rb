class AddEndTimeToLunchLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :end_time, :time
  end
end
