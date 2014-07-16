class ChangeLunchIdInHost < ActiveRecord::Migration
  def change
    rename_column :hosts, :lunchlearn_id, :event_id
  end
end
