module Skytap
  extend ActiveSupport::Concern

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

  module InstanceMethods
    def api_call(**kwargs)
      self.class.api_call(**kwargs)
    end
  end

  module ClassMethods
    @@skytap_url = 'https://cloud.skytap.com'
    @@auth_string = 'Basic TWF0dC5XYXRzb25Ab3Jhc2kuY29tOmRkMjc5NDA4YTlkNjRhZTA5YTA1MWExYzA2MzdlNzMwOWM1YmQyNjE='
    @@default_header = {'Authorization' => @@auth_string, 'Accept' => 'application/json' , 'Content-Type' => 'application/json', 'Cache-Control' => 'no-cache'}
    def api_call(request_type: 'get', request_path: '/', request_headers: {}, request_form_data: {})
      request_headers = @@default_header.merge!(request_headers)
      url = URI.parse(@@skytap_url + request_path)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      if request_type == 'get'
        req = Net::HTTP::Get.new(url.path)
      elsif request_type == 'post'
        req = Net::HTTP::Post.new(url.path)
      elsif request_type == 'put'
        req = Net::HTTP::Put.new(url.path)
      elsif request_type == 'delete'
        req = Net::HTTP::Delete.new(url.path)
      end

      req.initialize_http_header(request_headers)
      req.set_form_data(request_form_data)
      resp = http.start { |http| http.request(req) }

      JSON.parse(resp.body) unless resp.body.blank?

    end
  end
end