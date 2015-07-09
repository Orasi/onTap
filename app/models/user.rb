class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
  validates_inclusion_of :admin, in: [true, false]
  has_many :suggestions
  has_many :surveys
  has_one :profile
  has_one :environment

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
  end

  def get_ldap(admin_username, admin_password)
    ldap = Net::LDAP.new host: '10.238.240.27',
                         port: 389,
                         auth: {
                           method: :simple,
                           username: "ORASI\\#{admin_username}",
                           password: admin_password
                         }
    validated = ldap.bind
    ldap
  end

  def retrieve_picture(ldap)
    begin
      filter = Net::LDAP::Filter.eq('samaccountname', username.downcase)
      treebase = 'dc=orasi, dc=com'
      f = File.open(Rails.root.join('public', 'photos', first_name + last_name + '.jpg'), 'wb')
      thumbnail_array = ldap.search(base: treebase, filter: filter).first['thumbnailphoto'].first
      thumbnail_array.each_line { |line| f.puts line } unless thumbnail_array.nil?
      f.close
      unless thumbnail_array.nil?
        update_attribute('photo', '/photos/' + first_name + last_name + '.jpg')
      else
        update_attribute('photo', nil)
      end
    rescue Exception
      p "Error processing #{username}"
    end
  end

  def get_user_department
    bluesource_name=username
    template = ERB.new File.new("config/bluesource_api.yml").read
    @api_user = YAML.load template.result(binding)
    #@api_user = YAML.load_file(File.join(Rails.root, 'config', 'bluesource_api.yml'))[Rails.env]
    auth = {:username => @api_user[Rails.env]["username"], :password => @api_user[Rails.env]["password"]}
    begin
      department = HTTParty.get("https://bluesource.orasi.com/api/department.json?q=#{bluesource_name}", :basic_auth => auth, :verify => false)
      return department["name"]
    rescue 
      return ""
    end
  end

  def update_all_pictures(admin_password)
    ldap = get_ldap(username, admin_password)
    User.each do |u|
      u.retrieve_picture(ldap)
    end
  end
end
