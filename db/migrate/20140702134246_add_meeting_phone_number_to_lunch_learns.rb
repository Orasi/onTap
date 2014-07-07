class AddMeetingPhoneNumberToLunchLearns < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :meeting_phone_number, :string
  end
end
