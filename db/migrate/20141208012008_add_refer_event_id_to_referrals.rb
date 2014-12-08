class AddReferEventIdToReferrals < ActiveRecord::Migration
  def change
    add_column :referrals, :refer_event_id, :integer
  end
end
