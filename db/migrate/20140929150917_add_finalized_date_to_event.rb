class AddFinalizedDateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :finalized_date, :date
  end
end
