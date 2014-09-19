class Changehostknowledgeandhostpresentationtointegersinsurveys < ActiveRecord::Migration
  def change
    change_column :surveys, :host_knowledge, :integer
    change_column :surveys, :host_presentation, :integer
  end
end
