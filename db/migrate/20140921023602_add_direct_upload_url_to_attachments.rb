class AddDirectUploadUrlToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :direct_upload_url, :string
    add_column :attachments, :processed, :string
  end
end
