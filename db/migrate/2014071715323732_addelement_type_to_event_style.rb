class AddelementTypeToEventStyle < ActiveRecord::Migration
  def change
    add_column :event_styles, :element_type, :string
  end
end
