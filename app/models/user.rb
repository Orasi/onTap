class User < ActiveRecord::Base


  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :first_name, :last_name, presence: true
  validates_inclusion_of :admin,:in => [true, false]

  def display_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end
  
  def check_if_admin?
    self.admin
  end


end
