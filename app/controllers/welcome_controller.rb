class WelcomeController < ApplicationController
  def validate
    if validate_against_ad(login_params["username"], login_params["password"])
      redirect_to :root
    else
      redirect_to :login, flash: {error: "Invalid username or password."}
    end
  end

  private

  def validate_against_ad(username, password)
    #Do authentication against the AD.
    return false if password.blank?
    return true unless Rails.env.production?

    ldap = Net::LDAP.new :host => '10.238.242.32',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "ORASI\\#{username}",
      :password => password
    }
    return ldap.bind
  end

  def login_params
    params.require(:login).permit(:username, :password)
  end
end
