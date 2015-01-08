class AddDepartmentApprovalsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :department_approvals, :text
  end
end
