class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.integer :user_id
      t.integer :lunchlearn_id

      t.timestamps
    end
  end
end
