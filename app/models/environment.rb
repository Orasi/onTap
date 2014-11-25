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
    if id.blank?
      form_data = {
          'template_id' => template_id
      }
      json = api_call(request_type: 'post', request_path: '/configurations', request_form_data: form_data)
      puts '----------------------------------  Create Environment JSON ---------------------------'
      puts json
      puts '---------------------------------------------------------------------------------------'
      if (json['error'].blank?)
        self.id = json['id'].to_i
        return true
      else
        return false
      end
    end
  end

  def proccess
    change_environment_name
    remove_auto_suspend
    create_published_set
    create_delete_schedule(DateTime.now + 2.hours)
    change_runstate 'running'
    create_published_service '3389'
  end


  def change_environment_name
    form_data = {'name' => title}
    json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: form_data)
    puts '----------------------------------  Change Environment ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
  end
  handle_asynchronously :change_environment_name

  def get_details
    json = api_call(request_path: '/configurations/' + id.to_s)
    puts '----------------------------------  Environment Details ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
    json
  end

  def change_runstate(state)
    form_data = {'runstate' => state}
    Timeout.timeout(180) do
      loop do
        sleep(2)
        json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: form_data)
        puts '----------------------------------  Change Runstate JSON ---------------------------'
        puts json
        puts '---------------------------------------------------------------------------------------'
        self.update_attribute('status', 'In Queue')
        delay.wait_for_runstate state
        unless json['error']
          break
        end
      end
    end
  end
  handle_asynchronously :change_runstate, priority: 5

  def wait_for_runstate state
    self.update_attribute('status', 'loading')
    begin
      Timeout.timeout(180) do
        loop do
          sleep(5)
          current_state = api_call(request_path: '/configurations/' + id.to_s)['runstate']
          self.update(status: current_state)
          if current_state == state
            break
          end
        end
      end
    rescue
      self.update(status: 'error')
    end
  end
  handle_asynchronously :wait_for_runstate, priority: 5

  def remove_from_skytap
    Environment.delay.remove_from_skytap_async(id.to_s)
  end

  def self.remove_from_skytap_async(id)
    #begin
      Timeout.timeout(60) do
        loop do
          sleep(5)
          json = Environment.api_call(request_type: 'delete', request_path: '/configurations/' + id.to_s)
          puts '----------------------------------  Remove From Skytap ---------------------------'
          puts json if json
          puts 'Enviornment Deleted' unless json
          puts '---------------------------------------------------------------------------------------'
          if json.is_a?(Hash) && json['error']
            if json['error'] == "Couldn't get the requested environment"

              break
            end
          end
        end
      end
    #rescue Timeout::Error
      #puts '------------------------TIMEOUT------------------------------------'
      #puts '              Failed to delete environment'
     # puts '-------------------------------------------------------------------'
    #end
  end


  def remove_existing_environment
    puts '------------------------------------removing existing environment----------------------------------'
    unless User.find(user_id).environment.nil?
      puts '----------------------------------existing environment found-------------------------------------'
      User.find(user_id).environment.remove_from_skytap
      Environment.where(user_id: user_id).delete_all
      puts '----------------------------------existing environment deleted-------------------------------------'
    end
  end


  def create_published_set
    form_data = {name: 'published_set', published_set_type: 'single_url'}

    json = api_call(request_type: 'post', request_path: '/configurations/' + id.to_s + '/publish_sets', request_form_data: form_data)
    puts '----------------------------------  Create Published Set ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
    unless json['vms'][0]['desktop_url'].blank?
      update(published_url: json['vms'][0]['desktop_url'])
    else
      update(published_url: 'error generating published url')
      update(status: 'error')
    end
    json
  end
  handle_asynchronously :create_published_set, priority: 5

  def create_delete_schedule expiration
    form_data = {title: 'delete_schedule', configuration_id: id, start_at: expiration, end_at: expiration + 1.minute, delete_at_end: true, time_zone: 'Eastern Time (US & Canada)'}
    update(expiration: expiration)
    json = api_call(request_type: 'post', request_path: '/schedules', request_form_data: form_data)
    puts '----------------------------------  Create Delete Schedule JSON ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
    if json['id']
      update(schedule_id: json['id'])
    else
      update(status: 'error')
    end
    json
  end
  handle_asynchronously :create_delete_schedule, priority: 5

  def extend_delete_schedule hours
    json = api_call(request_type: 'delete', request_path: '/schedules/' + schedule_id.to_s)
    puts '----------------------------------  Remove Delete Schedule JSON ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
    new_expiration = expiration.to_datetime + hours.hours
    update(expiration: new_expiration)
    create_delete_schedule_without_delay new_expiration
  end

  def create_published_service port
    get_first_vm
    get_first_interface
    return_or_create_service port
  end
  handle_asynchronously :create_published_service, priority: 3

  def get_first_vm
    vms = api_call(request_path: '/configurations/' + id.to_s + '/vms')
    puts '----------------------------------  List Environment VMs JSON ---------------------------'
    puts vms
    puts '---------------------------------------------------------------------------------------'
    if vms.count > 0
      @vm = vms[0]
    end
  end

  def get_first_interface
    @interface = api_call(request_path: '/configurations/' + id.to_s + '/vms/' + @vm['id'] + '/interfaces')[0]
    puts '----------------------------------  Interface for First VM JSON ---------------------------'
    puts @interface
    puts '---------------------------------------------------------------------------------------'
  end

  def remove_auto_suspend
    json = api_call(request_type: 'put', request_path: '/configurations/' + id.to_s, request_form_data: { suspend_on_idle: ''})
    puts '----------------------------------  Remove Auto Suspend JSON ---------------------------'
    puts json
    puts '---------------------------------------------------------------------------------------'
  end
  handle_asynchronously :remove_auto_suspend, priority: 5

  def return_or_create_service port
    form_data = { port: port}
    Timeout.timeout(180) do
      loop do
        sleep(5)
        json = api_call(request_type: 'post', request_path: '/configurations/' + id.to_s + '/vms/' + @vm['id'] + '/interfaces/' + @interface['id'] + '/services', request_form_data: form_data)
        puts '----------------------------------  Create Published Service JSON ---------------------------'
        puts json
        puts '---------------------------------------------------------------------------------------'
        unless json['error']
          update(rdp_address: json['external_ip'].to_s + ':' + json['external_port'].to_s)
          break
        end
        json
      end
    end
  end
end
