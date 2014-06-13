class User < ActiveRecord::Base


  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: {in: ->(employee) {employee.class.roles}}

  def display_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end

  #For user roles
  def self.roles
    ["Attendee","Host","Admin"]
  end
end
