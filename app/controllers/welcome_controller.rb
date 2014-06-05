class WelcomeController < ApplicationController
  def index
  end

  def login
  end

  def validate
    if validate_against_ad(params["login"]["username"], params["login"]["password"])
      redirect_to :root
    else
      redirect_to :login, flash: {error: "Invalid username or password."}
    end
  end

  private

  def validate_against_ad(username, password)
    #Do authentication against the AD.
    return false if password.blank?
    #return true unless Rails.env.production?

    ldap = Net::LDAP.new :host => '10.238.242.32',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "ORASI\\#{username}",
      :password => password
    }
    return ldap.bind
  end
end
