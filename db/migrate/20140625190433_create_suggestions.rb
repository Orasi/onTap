class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.integer :user_id
      t.string :suggestion_title
      t.string :suggestion_description

      t.timestamps
    end
  end
end
