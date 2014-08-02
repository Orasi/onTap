class Attachment < ActiveRecord::Base
  validates :file_file_name, presence: true
  belongs_to :event
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => /\A.*\Z/
  process_in_background :file
end
