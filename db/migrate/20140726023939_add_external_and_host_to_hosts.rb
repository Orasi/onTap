class AddExternalAndHostToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :external, :boolean
    add_column :hosts, :host, :string
  end
end
