class AddReferSenderToReferral < ActiveRecord::Migration
  def change
    add_column :referrals, :refer_sender_id, :integer
  end
end
