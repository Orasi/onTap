class AddLabIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lab_id, :integer
  end
end
