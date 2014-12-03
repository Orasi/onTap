class Referral < ActiveRecord::Base

  validates_presence_of :refer_email, :refer_sender_id, :refer_message
  validate :validate_email_format

  def validate_email_format
    emails = self.refer_email.downcase.split(',')
    emails.each do |email|
      self.errors.add(:refer_email, "Emails should be in the format name@domain.  Multiple emails should be seperate by commas.") unless email.strip=~ /^([^\s]+)@([^\s]+)$/i
    end
  end

end
