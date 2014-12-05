class AddPublicToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :public, :boolean
  end
end
