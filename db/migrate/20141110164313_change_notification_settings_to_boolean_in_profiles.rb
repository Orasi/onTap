class ChangeNotificationSettingsToBooleanInProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :notification_settings, 'boolean USING CAST(notification_settings AS boolean)'
  end
end
