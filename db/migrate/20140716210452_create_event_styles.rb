class CreateEventStyles < ActiveRecord::Migration
  def change
    create_table :event_styles do |t|

      t.timestamps
    end
  end
end
