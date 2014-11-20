class Attachment < ActiveRecord::Base
  validates :file_file_name, presence: true
  belongs_to :event
  has_attached_file :file,   s3_permissions: :private
  validates_attachment_content_type :file, content_type: /\A.*\Z/

  before_create :set_upload_attributes
  after_create :queue_processing

  # Environment-specific direct upload url verifier screens for malicious posted upload locations.
  # DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/orasitest\.s3\.amazonaws\.com\/uploads\/.+\/(?<file_file_name>.+)\z}.freeze
  #  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/orasitest\.s3\.amazonaws\.com\/uploads\/.*\z}.freeze
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/orasitest\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze
ssh
  # process_in_background :file

  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
   end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    attachment = Attachment.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(attachment.direct_upload_url)
    s3 = AWS::S3.new

    paperclip_file_path = "attachments/files/#{id}/original/#{direct_upload_url_data[:filename]}"
    s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])

    attachment.processed = true
    attachment.save

    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end
 # Queue file processing
  def queue_processing
    Attachment.delay.transfer_and_cleanup(id)
  end
  protected

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head

    self.file_file_name     = direct_upload_url_data[:filename]
    self.file_file_size     = direct_upload_head.content_length
    self.file_content_type  = direct_upload_head.content_type
    self.file_updated_at    = direct_upload_head.last_modified
    # rescue AWS::S3::Errors::NoSuchKey => e
    #  tries -= 1
    #  if tries > 0
    #    sleep(3)
    #    retry
    #  else
    #    false
    #  end
  end

 
end
