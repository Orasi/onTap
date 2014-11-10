class AddScheduleIdToEnvironments < ActiveRecord::Migration
  def change
    add_column :environments, :schedule_id, :string
  end
end
