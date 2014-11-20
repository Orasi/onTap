class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.belongs_to :template
      t.belongs_to :user
      t.datetime :expiration
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
