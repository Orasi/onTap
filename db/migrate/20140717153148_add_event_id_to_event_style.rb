class AddEventIdToEventStyle < ActiveRecord::Migration
  def change
    add_column :event_styles, :event_id, :integer
  end
end
