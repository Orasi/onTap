class AddGoToMeetingUrlToLunchLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :go_to_meeting_url, :string
  end
end
