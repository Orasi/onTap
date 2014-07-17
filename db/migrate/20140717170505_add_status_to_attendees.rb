class AddStatusToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :status, :string
  end
end
