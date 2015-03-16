class ChangeEnvironmentDetailsToText < ActiveRecord::Migration
  def change
    change_column :environments, :description, :text
    change_column :templates, :description, :text
  end
end
