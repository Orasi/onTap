class AddelementIdToEventStyle < ActiveRecord::Migration
  def change
    add_column :event_styles, :element_id, :integer
  end
end
