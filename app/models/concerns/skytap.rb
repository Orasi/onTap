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

    def skytap_log
      self.class.skytap_log(user_name: User.find(self.user_id).username)
    end

    def log_json(step_name, message)
      self.class.log_json(step_name, message)
    end
  end

  module ClassMethods
    @@skytap_url = 'https://cloud.skytap.com'
    @@auth_string = 'Basic T250YXBMYWJzOjQ3MWZiZTAyYWNkM2ZiMDU1ZjJlMzY3ZTk0MWUyOGMzMWM4MGY2ZTI='
    @@default_header = { 'Authorization' => @@auth_string, 'Accept' => 'application/json', 'Content-Type' => 'application/json', 'Cache-Control' => 'no-cache' }
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

    def skytap_log(user_name= '')
      @@skytap_log ||= Logger.new("#{Rails.root}/log/skytap.log")
      @@skytap_log.formatter = proc do |sev, dt, prog, msg|
        "#{user_name}-#{sev}: #{msg}"
      end
      return @@skytap_log
    end

    def log_json step_name, message
      msg ="------ #{step_name} -------\n" +
          message.to_s + "\n" +
          "-------#{DateTime.now.utc}-------\n\n"
      skytap_log.info(msg)
    end
  end
end
