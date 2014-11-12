class ChangeNotificationSettingsToBooleanInProfiles < ActiveRecord::Migration
  def change

    remove_column :profiles, :notification_settings
    add_column :profiles, :notification_settings, :boolean, default: true
  end
end
