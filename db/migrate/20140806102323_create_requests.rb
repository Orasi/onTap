class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :manager_id
      t.integer :status
      t.integer :notification_type

      t.timestamps
    end
  end
end
