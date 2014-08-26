class Changestatusandnotifcationinrequests < ActiveRecord::Migration
  def change
    change_column :requests, :status, :string
    change_column :requests, :notification_type, :string
  end
end
