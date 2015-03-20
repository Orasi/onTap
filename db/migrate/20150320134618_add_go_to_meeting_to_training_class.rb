class AddGoToMeetingToTrainingClass < ActiveRecord::Migration
  def change
    add_column :training_classes, :has_GoToMeeting, :boolean
    add_column :training_classes, :access_code, :text
    add_column :training_classes, :go_to_meeting_url, :text
    add_column :training_classes, :meeting_phone_number, :text
  end
end
