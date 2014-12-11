require 'test_helper'

class EnvironmentTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
  end

  test 'creation stops if environment can not be created' do
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111/).
        to_return(:status => 200, :body => {id: 111}.to_json.to_s, :headers => {})
    @template = Template.create( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)

    WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations/).
        with(:body => {"template_id"=>"111"},
             :headers => {'Accept'=>'application/json', 'Cache-Control'=>'no-cache', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return(:status => 200, :body => {error: 'OH NOES!'}.to_json.to_s, :headers => {})
    old_count = Environment.all.count
    @env = @template.create_environment(@user)
    assert_equal old_count, Environment.all.count
  end

  def stubs
    #stub template check
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111/).
        to_return(:status => 200, :body => {id: 111, vms: [{id: "4077776", runstate: "suspended", error: false, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}]}.to_json.to_s, :headers => {})

    #stub environment creation
    WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/configurations/).
        to_return(:status => 200, :body => {id: 123123, vms: [{id: "4077776", runstate: "suspended", error: false, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}]}.to_json.to_s, :headers => {})

    #stub to change environment
    WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123/).
        with(:body => {"name"=> /test first\.last.*/}).
        to_return(:status => 200, :body =>  {id: 123123}.to_json.to_s, :headers => {})
    WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123/).
        with(:body => {"suspend_on_idle"=>""}).
        to_return(:status => 200, :body =>  {id: 123123}.to_json.to_s, :headers => {})

    #stub create delete schedule
    WebMock.stub_request(:post, /https:\/\/.*cloud\.skytap\.com\/schedules/).
        to_return(:status => 200, :body => {id: 123123}.to_json.to_s, :headers => {})

    #stub change run state
    WebMock.stub_request(:put, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123/).
        with(:body => {"runstate"=>"running"}).
        to_return(:status => 200, :body => {id: 123123, runstate: 'running'}.to_json.to_s, :headers => {})

    #stub get vms
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123\/vms\/4077776\/interfaces/).
        to_return(:status => 200, :body => [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}].to_json.to_s, :headers => {})
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/configurations\/123123/).
        to_return(:status => 200, :body => [{id: "4077776", runstate: "suspended", error: false, interfaces: [{"id"=>"nic-1695630-4014316-0", "ip"=>"10.0.0.1", "hostname"=>"administrator", "mac"=>"00:50:56:3A:32:AD", "services_count"=>0, "services"=>[], "public_ips_count"=>0, "public_ips"=>[], "status"=>"Suspended", "vm_name"=>"Windows_7_Office2010_X86_UFT115", "vm_id"=>"4077776", "network_name"=>"Network 1", "network_subnet"=>"10.0.0.0/24", "network_id"=>"1775634", "network_type"=>"automatic", "nic_type"=>"e1000"}]}].to_json.to_s, :headers => {})

  end
 
  test 'can create environment from template' do
    stubs
    @template = Template.create( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)


    old_count = Environment.all.count
    @env = @template.create_environment(@user)
    assert_equal old_count + 1, Environment.all.count
    assert_equal @env.id, 123123
  end

end
