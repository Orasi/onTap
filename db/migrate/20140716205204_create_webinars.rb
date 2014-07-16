class CreateWebinars < ActiveRecord::Migration
  def change
    create_table :webinars do |t|

      t.timestamps
    end
  end
end
