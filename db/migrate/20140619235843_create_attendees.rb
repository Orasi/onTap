class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.belongs_to :user
      t.belongs_to :lunchlearn
      t.timestamps
    end
  end
end
