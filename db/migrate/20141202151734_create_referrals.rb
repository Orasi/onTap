class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :refer_email
      t.text :refer_message

      t.timestamps
    end
  end
end
