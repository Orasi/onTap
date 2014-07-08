class AddHasGoToMeetingToLunchLearn < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :has_GoToMeeting, :boolean
  end
end
