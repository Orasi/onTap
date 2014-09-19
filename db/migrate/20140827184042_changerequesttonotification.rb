class Changerequesttonotification < ActiveRecord::Migration
  def change
    rename_table :requests, :notifications
  end
end
