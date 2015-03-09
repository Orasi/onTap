class AddVisibilityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :limited_visibility, :boolean
    add_column :events, :visible_to_departments, :text
  end
end
