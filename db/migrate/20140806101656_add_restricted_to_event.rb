class AddRestrictedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :restricted, :boolean
  end
end
