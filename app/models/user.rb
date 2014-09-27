class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validates_inclusion_of :admin, in: [true, false]
  has_many :suggestions
  has_many :surveys

  def display_name
    first_name.capitalize + ' ' + last_name.capitalize
  end

  def check_if_admin?
    admin
  end

  def self.find_or_create(username, display_name, email)
    # Find the user by their username
    user = User.find_by(username: username.downcase)

    # If the user doesn't exist make a new user. Split their username to get their first name and last name
    if user.nil?
      user = User.new
      user.username = username.downcase
      user.first_name, user.last_name = display_name.split(' ')
      user.email = email
      user.admin = false
      user.username = "#{user.first_name}#{user.last_name}".downcase if user.first_name.length == 1
    end

    user
  end

  def validate_against_ad(password)
    # Do authentication against the AD.
    return false if password.blank?
    unless Rails.env.production?
      self.first_name, self.last_name = username.downcase.split('.') if first_name.blank? || last_name.blank?
      self.admin = false if admin.blank?
      self.email = "#{username.downcase}@orasi.com" if email.blank?
      return true
    end

    ldap = Net::LDAP.new host: '10.238.240.27',
                         port: 389,
                         auth: {
                           method: :simple,
                           username: "ORASI\\#{username}",
                           password: password
                         }
    validated = ldap.bind
    if validated and (first_name.blank? || last_name.blank? || photo.blank? || email.blank?)

      filter = Net::LDAP::Filter.eq('samaccountname', username)
      treebase = 'dc=orasi, dc=com'
      self.first_name, self.last_name = ldap.search(
        base: treebase,
        filter: filter,
        attributes: %w(displayname)
      ).first.displayname.first.downcase.split(' ')
      retrieve_picture(ldap)
      self.email = ldap.search(
        base: treebase,
        filter: filter,
        attributes: %w(mail)
      ).first.mail.first.downcase

    end

    validated
  end

  def retrieve_picture(ldap)
    filter = Net::LDAP::Filter.eq('samaccountname', username.downcase)
    treebase = 'dc=orasi, dc=com'
    f = File.open(Rails.root.join('public', 'photos', first_name + last_name + '.jpg'), 'wb')
    thumbnail_array = ldap.search(base: treebase, filter: filter).first['thumbnailphoto'].first
    thumbnail_array.each_line { |line| f.puts line } unless thumbnail_array.nil?
    f.close
    unless thumbnail_array.nil?
      self.photo = '/photos/' + first_name + last_name + '.jpg'
    else
      self.photo = nil
    end
  end
end
