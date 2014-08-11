class RemoveViewsFromLunchlearns < ActiveRecord::Migration
  def change
    remove_column :lunchlearns, :views
    remove_column :webinars, :views
    remove_column :training_classes, :views
  end
end

