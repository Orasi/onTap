class CreateAttendRequests < ActiveRecord::Migration
  def change
    create_table :attend_requests do |t|
      t.integer :event_id
      t.integer :requester_id
      t.integer :manager_id
      t.integer :status

      t.timestamps
    end
  end
end
