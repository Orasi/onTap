class Changehostknowledgeandhostpresentationtointegersinsurveys < ActiveRecord::Migration
  def change
    change_column :surveys, :host_knowledge, 'integer USING CAST("host_knowledge" AS integer)'
    change_column :surveys, :host_presentation, 'integer USING CAST("host_presentation" AS integer)'
  end
end
