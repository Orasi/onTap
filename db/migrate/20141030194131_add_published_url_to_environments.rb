class AddPublishedUrlToEnvironments < ActiveRecord::Migration
  def change
    add_column :environments, :published_url, :string
  end
end
