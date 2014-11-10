class ChangeNotificationSettingsToBooleanInProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :notification_settings, :boolean
  end
end
