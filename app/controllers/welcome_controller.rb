class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [:validate, :login]

  protect_from_forgery except: :validate

  def login

    if current_user
      redirect_to :calendar
      return
    end

    if Rails.env.production?
      saml_request = OneLogin::RubySaml::Authrequest.new
      redirect_to(saml_request.create(saml_settings))
      return
    end
    
  end

  def validate

    if Rails.env.production?
      saml_response = saml_validation
      username = saml_response.name_id
      display_name = saml_response.attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
      email = saml_response.attributes['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']
    else
      username = params[:login][:username]
      display_name = "Test User"
      email = "test.user@orasi.com"
    end
    
    @user = User.find_or_create(username.downcase, display_name, email)
    unless Rails.env.production?
  #    redirect_to :login, flash: { error: 'Invalid username or password' }
  #    return
    end
    @saml = saml_response
    if @user.save
	     session[:current_user_id] = @user.id
	     Session.create(session_id: session[:session_id])
      if session[:return_to]
        url = session[:return_to]
        session[:return_to] = nil
        redirect_to url
      else
        redirect_to :calendar
      end
      
    else
	     redirect_to :login, flash: { error: 'Unknown Error' }
	     # TODO: User Validation errors reporting
    end
  end

  def logout
    @_current_user = session[:current_user_id] = nil

    if Rails.env.production?
     
      redirect_to 'https://adfs.orasi.com/adfs/ls/?wa=wsignout1.0&wreply=https://ontap.orasi.com'
    else
      redirect_to :login
    end
  end

  private


  def saml_validation
    response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    response
  end

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new
    settings.assertion_consumer_service_url = ENV['OT_ASSERTION_CONSUMER_SERVICE_URL']
    settings.issuer = ENV['OT_ISSUER']
    settings.idp_sso_target_url = ENV['OT_IDP_SSO_TARGET_URL']
    settings.idp_cert_fingerprint = ENV['OT_IDP_CERT_FINGERPRINT']

    settings
  end
end
