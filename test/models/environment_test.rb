require 'test_helper'

class EnvironmentTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
  end

  def stubs with_error: [], return_nil: []
    #stub template check
    unless with_error.include?('check_template')
      WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111\Z/).
          to_return(:status => 200, :body => {id: 111, vms: [{id: "4077776", runstate: "suspended", error: false, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}]}.to_json.to_s, :headers => {})
    else
      WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111\Z/).
          to_return(:status => 200, :body => {error: 'OH NOES!'}.to_json, :headers => {})
    end

    #stub environment creation
    unless with_error.include?('create_environment')
      WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations\Z/).
          to_return(:status => 200, :body => {id: 123123, vms: [{id: "4077776", desktop_url: 'http://something.com', runstate: "suspended", error: nil, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}]}.to_json.to_s, :headers => {})
    else
      WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations\Z/).
          to_return(:status => 200, :body => {error: 'OH NOES!'}.to_json, :headers => {})
    end

    #stub to change environment
    unless with_error.include?('change_name')
      WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\Z/).
          with(:body => {"name"=> /test first\.last.*/}).
          to_return(:status => 200, :body =>  {id: 123123}.to_json.to_s, :headers => {})
    else
      WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\Z/).
          with(:body => {"name"=> /test first\.last.*/}).
          to_return(:status => 200, :body =>  {error: 'OH NOES!'}.to_json, :headers => {})
    end

    unless with_error.include?('change_suspend')
      WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\Z/).
          with(:body => {"suspend_on_idle"=>""}).
          to_return(:status => 200, :body =>  {id: 123123}.to_json.to_s, :headers => {})
    end

    #stub create delete schedule
    unless with_error.include?('create_delete')
      WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/schedules\Z/).
          to_return(:status => 200, :body => {id: 123123}.to_json.to_s, :headers => {})
    end

    #stub change run state
    unless with_error.include?('change_runstate')
      WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\Z/).
          with(:body => {"runstate"=>"running"}).
          to_return(:status => 200, :body => {id: 123123, runstate: 'running'}.to_json.to_s, :headers => {})
    end

    #stub get vms
    unless with_error.include?('get_interface')
      WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\/vms\/.*\/interfaces\Z/).
          to_return(:status => 200, :body => [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}].to_json.to_s, :headers => {})
    end
     WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/configurations\/.*\/vms\Z/).
        to_return(:status => 200, :body => [{id: "4077776", runstate: "suspended", error: nil, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}].to_json.to_s, :headers => {})
    unless with_error.include?('get_details')
      WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\Z/).
          to_return(:status => 200, :body => {id: "4077776", runstate: "running", error: nil, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}.to_json.to_s, :headers => {})
    end

    WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\/publish_sets\Z/).
        to_return(:status => 200, :body => {id: 123123, vms: [{id: "4077776", desktop_url: 'http://something.com', runstate: "suspended", error: nil, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}]}.to_json.to_s, :headers => {})

    WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations\/.*\/vms\/.*\/interfaces\/.*\/services\Z/).
        to_return(:status => 200, :body => {external_ip: '1.1.1.1', external_port: '1234'}.to_json, :headers => {})
  end
 
  test 'can create environment from template' do
    stubs
    @template = Template.create( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)

    old_count = Environment.all.count
    @env = @template.create_environment(@user)
    assert_equal old_count + 1, Environment.all.count
    assert_equal @env.id, 123123
  end

  test 'environment created with error if not in skytap' do
    stubs with_error: ['create_environment']
    @template = Template.create( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)

    old_count = Environment.all.count
    @env = @template.create_environment(@user)
    assert_equal old_count + 1, Environment.all.count
    assert_equal 'error', @env.status
  end

  test 'environment has error status if name can not be changed' do
    skip
    stubs with_error: ['change_name']
    @template = Template.create( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)

    old_count = Environment.all.count
    @env = @template.create_environment(@user)
    assert_equal old_count + 1, Environment.all.count
    assert_equal 'error', @env.status
  end
end
