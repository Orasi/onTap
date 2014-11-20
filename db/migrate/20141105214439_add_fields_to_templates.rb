class AddFieldsToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :username, :string
    add_column :templates, :password, :string
    add_column :templates, :properties, :text
  end
end
