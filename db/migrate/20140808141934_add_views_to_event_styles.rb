class AddViewsToEventStyles < ActiveRecord::Migration
  def change
	add_column :lunchlearns, :views, :string
	add_column :webinars, :views, :string
	add_column :training_classes, :views, :string
  end
end
