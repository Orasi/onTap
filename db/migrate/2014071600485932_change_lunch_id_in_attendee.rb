class ChangeLunchIdInAttendee < ActiveRecord::Migration
  def change
    rename_column :attendees, :lunchlearn_id, :event_id
  end
end
