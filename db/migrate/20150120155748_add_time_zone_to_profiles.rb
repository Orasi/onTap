class AddTimeZoneToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :time_zone, :string
  end
end
