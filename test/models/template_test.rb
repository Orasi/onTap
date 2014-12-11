require 'test_helper'
require 'webmock/test_unit'
class TemplateTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create(:normal_user)
    assert @user
  end

  test 'can create template if exists in skytap' do

    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111/).
        to_return(:status => 200, :body => {id: 111}.to_json.to_s, :headers => {})
    @template = Template.new( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)
    assert @template.save
  end

  test 'can not create template if it does not exist in skytap' do
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111/).
        to_return(:status => 403, :body => {error: 'OH NOES!'}.to_json.to_s, :headers => {})
    @template = Template.new( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)
    assert_not @template.save
  end

  test 'can not create template if it no response from skytap' do
    WebMock.stub_request(:get, /https:\/\/.*cloud\.skytap\.com\/templates\/111/).
        to_return(:status => 403, :body => nil, :headers => {})
    @template = Template.new( id: 111, title: 'test', description: 'test', username: 'test', password: 'test', properties: 'test;test;test', public: true)
    assert_not @template.save
  end

end
