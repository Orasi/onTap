class RemoveEventTypeFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :event_type
  end
end
