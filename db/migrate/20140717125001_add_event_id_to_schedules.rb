class AddEventIdToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :event_id, :integer
  end
end
