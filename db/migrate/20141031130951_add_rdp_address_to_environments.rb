class AddRdpAddressToEnvironments < ActiveRecord::Migration
  def change
    add_column :environments, :rdp_address, :string
  end
end
