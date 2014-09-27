class Add < ActiveRecord::Migration
  def change
        add_column :users, :weekly_mailer, :bool
  end
end
