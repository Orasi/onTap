class MoveLunchTimeToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :lunch_date, :date
    add_column :schedules, :lunch_time, :time
    add_column :schedules, :end_time, :time
    remove_column :lunchlearns, :lunch_date
    remove_column :lunchlearns, :lunch_time
    remove_column :lunchlearns, :end_time
  end

  def self.down
  end
end
