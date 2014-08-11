require 'test_helper'

class HostTest < ActiveSupport::TestCase
  def setup
    @event = FactoryGirl.create(:lunchlearnstyle)
    @user = FactoryGirl.create(:normal_user)
  end
  test 'should save host' do
    host = @event.hosts.new(user_id: FactoryGirl.create(:normal_user).id)
    assert host.save
  end
  
  test 'should delete host' do
    host = @event.hosts.create(user_id: FactoryGirl.create(:normal_user).id)
    host_id = host.id
    host.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      Host.find(host_id)
    end
  end

  test 'should increment host count' do
    host_count = @event.hosts.count
    host = @event.hosts.create(user_id: @user.id)
    assert_equal host_count + 1, @event.hosts.count    
  end

  test "host should not save with out user_id" do
    host = @event.hosts.new(user_id: nil)
    assert_raises ActiveRecord::RecordInvalid do
       host.save!
    end
  end

  test 'host should not save with out event_id' do 
    host = Host.new(user_id: @user.id)
    assert_raises ActiveRecord::RecordInvalid do
       host.save!
    end
  end

#  test 'host should not save unless unique' do 
#    @event.hosts.create(user_id: @user.id)
#    host = @event.hosts.create(user_id: @user.id)
#    assert_raises ActiveRecord::RecordInvalid do
#       host.save!
#    end
#  end
  
#  test 'host should be deleted when event is deleted' do
#    @eventDel.hosts.create(user_id: @user.id)
#    event_id = @eventDel.id
#    @eventDel.destroy
#    assert_equal 0, Host.where(lunchlearn_id: event_id).count
#  end
end
