class AddUrlToWebinar < ActiveRecord::Migration
  def change
    add_column :webinars, :url, :string
  end
end
