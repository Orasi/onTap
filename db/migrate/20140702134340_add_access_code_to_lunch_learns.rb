class AddAccessCodeToLunchLearns < ActiveRecord::Migration
  def change
    add_column :lunchlearns, :access_code, :string
  end
end
