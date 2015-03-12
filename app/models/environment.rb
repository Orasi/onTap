require 'timeout'
class Environment < ActiveRecord::Base
  include Skytap

  before_create :add_to_skytap
  after_create :proccess
  before_destroy :remove_from_skytap
  belongs_to :template
  belongs_to :user
  attr_accessor :vm, :interface, :service, :rdp_service

  def add_to_skytap
    remove_existing_environment
    form_data = {
      'template_id' => template_id
    }
    json = api_call(request_type: 'post', request_path: '/configurations', request_form_data: form_data)
    log_json 'Create Environment JSON', json
    if !json.nil? && json['error']
      self.id = json['id'].to_i
    else
      self.status = 'error'
    end
  end

  def proccess
    unless self.status == 'error'
      create_published_service '3389'
      change_environment_name
      remove_auto_suspend
      create_published_set
      create_delete_schedule(DateTime.now + 2.hours)
      change_runstate 'running'
      wait_for_runstate 'running'
    end
  end

  def change_environment_name
    unless self.status == 'error'
      begin
        Timeout.timeout(30) do
          loop do
            form_data = { 'name' => title }
            json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: form_data)
            log_json 'Change Environment Name', json
            if json[:error]
              break
            else
              update(status: 'error')
              break if Rails.env == 'test'
            end
          end
        end
      rescue
        update(status: 'error')
      end
    end
  end
  handle_asynchronously :change_environment_name

  def get_details
    json = api_call(request_path: '/configurations/' + id.to_s)
    log_json 'Environment Details', json
    return json
  end

  def change_runstate(state)
    unless self.status == 'error'
      form_data = { 'runstate' => state }
      Timeout.timeout(180) do
        loop do
          sleep(2)
          json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: form_data)
          log_json 'Change Runstate JSON', json
          update_attribute('status', 'In Queue')
          unless json['error']
            break
          end
        end
      end
    end
  end
  handle_asynchronously :change_runstate, priority: 5

  def wait_for_runstate(state)
    unless self.status == 'error'
      update_attribute('status', 'loading')
      begin
        Timeout.timeout(180) do
          loop do
            sleep(5)
            current_state = api_call(request_path: '/configurations/' + id.to_s)
            log_json 'Wait For Runstate', current_state
            current_runstate = current_state['runstate']
            update(status: current_runstate)
            if current_runstate == state
              break
            end
          end
        end
      rescue
        skytap_log.error('Timed out while waiting for runstate')
        update(status: 'error')
      end
    end
  end
  handle_asynchronously :wait_for_runstate, priority: 5

  def remove_from_skytap
    Environment.delay.remove_from_skytap_async(id.to_s)
  end

  def self.remove_from_skytap_async(id)
    begin
      Timeout.timeout(60) do
        loop do
          sleep(5)
          json = Environment.api_call(request_type: 'delete', request_path: '/configurations/' + id.to_s)
          log_json 'Remove From Skytap', json
          if json.is_a?(Hash) && json['error']
            if json['error'] == "Couldn't get the requested environment"
              skytap_log.info('Environment Removed')
              break
            end
          end
        end
      end
    rescue Timeout::Error
      skytap_log.error('Timeout occurred while trying to remove Environment')
   end
  end

  def remove_existing_environment
    unless User.find(user_id).environment.nil?

      User.find(user_id).environment.remove_from_skytap
      envs = Environment.where(user_id: user_id)
      if envs.count > 0
        skytap_log.info('Existing environment found.  Attempting to remove')
        envs.delete_all
        skytap_log.info('Environments removed')
      end

    end
  end

  def create_published_set
    unless self.status == 'error'
      form_data = { name: 'published_set', published_set_type: 'single_url' }

      json = api_call(request_type: 'post', request_path: '/configurations/' + id.to_s + '/publish_sets', request_form_data: form_data)
      log_json 'Create Published Set', json
      unless json['vms'][0]['desktop_url'].blank?
        update(published_url: json['vms'][0]['desktop_url'])
      else
        update(published_url: 'error generating published url')
        update(status: 'error')
      end
    end
  end
  handle_asynchronously :create_published_set, priority: 5

  def create_delete_schedule(expiration)
    unless self.status == 'error'
      form_data = { title: 'delete_schedule', configuration_id: id, start_at: expiration, end_at: expiration + 1.minute, delete_at_end: true, time_zone: 'Eastern Time (US & Canada)' }
      update(expiration: expiration)
      json = api_call(request_type: 'post', request_path: '/schedules', request_form_data: form_data)
      log_json 'Create Delete Schedule JSON', json
      if json['id']
        update(schedule_id: json['id'])
      else
        update(status: 'error')
      end
    end
  end
  handle_asynchronously :create_delete_schedule, priority: 5

  def extend_delete_schedule(hours)
    json = api_call(request_type: 'delete', request_path: '/schedules/' + schedule_id.to_s)
    log_json 'Remove Delete Schedule JSON', json
    new_expiration = expiration.to_datetime + hours.hours
    update(expiration: new_expiration)
    create_delete_schedule_without_delay new_expiration
  end

  def create_published_service(port)
    unless self.status == 'error'
      get_first_vm
      get_first_interface
      return_or_create_service port
    end
  end
  handle_asynchronously :create_published_service, priority: 2

  def get_first_vm
    vms = api_call(request_path: '/configurations/' + id.to_s + '/vms')
    log_json 'List Environment VMs JSON', vms
    if vms.count > 0
      @vm = vms[0]
    end
  end

  def get_first_interface
    @interface = api_call(request_path: '/configurations/' + id.to_s + '/vms/' + @vm['id'] + '/interfaces')
    @interface= @interface[0]
    log_json 'Interface for First VM JSON', @interface
  end

  def remove_auto_suspend
    unless self.status == 'error'
      json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: { suspend_on_idle: '' })
      log_json 'Remove Auto Suspend JSON', json
    end
  end
  handle_asynchronously :remove_auto_suspend, priority: 5

  def return_or_create_service(port)
    form_data = { port: port }
    Timeout.timeout(180) do
      loop do
        sleep(5)
        json = api_call(request_type: 'post', request_path: '/configurations/' + id.to_s + '/vms/' + @vm['id'] + '/interfaces/' + @interface['id'] + '/services', request_form_data: form_data)
        log_json 'Create Published Service JSON', json
        unless json['error']
          update(rdp_address: json['external_ip'].to_s + ':' + json['external_port'].to_s)
          break
        end
        json
      end
    end
  end
end
