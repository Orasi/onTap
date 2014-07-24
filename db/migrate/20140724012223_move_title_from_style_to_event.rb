class MoveTitleFromStyleToEvent < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
    add_column :events, :description, :string
    Event.all.each do |e|
      e.title = e.event_style.element.title
      e.description = e.event_style.element.description
    end
    remove_column :lunchlearns, :title
    remove_column :lunchlearns, :description
  end
end
