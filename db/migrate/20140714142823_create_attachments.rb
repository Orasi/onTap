class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :title
      t.belongs_to :lunchlearn
      t.timestamps
    end
  end
end
