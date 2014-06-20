class AddDateToLunchLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :lunch_date, :date
  end
end
