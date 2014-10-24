class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :food_pref
      t.string :location
      t.string :notification_settings

      t.timestamps
    end
  end
end
