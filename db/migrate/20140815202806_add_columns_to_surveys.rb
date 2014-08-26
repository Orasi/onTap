class AddColumnsToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :went_well, :text
    add_column :surveys, :improved, :text
    add_column :surveys, :host_knowledge, :text
    add_column :surveys, :host_presentation, :text
    add_column :surveys, :effect, :text
    add_column :surveys, :extra, :text
  end
end
