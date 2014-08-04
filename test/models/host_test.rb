require 'test_helper'

class HostTest < ActiveSupport::TestCase
#  def setup 
#    first_name = Faker::Name.first_name
#    last_name = Faker::Name.last_name
#    @event=lunchlearns(:lunchone)
#    @eventDel = Lunchlearn.create(title: "Forward Usability Representative", description: "Try to reboot the HDD capacitor, maybe it will conn...", created_at: "2014-07-15 03:20:14", updated_at: "2014-07-15 03:20:14", lunch_date: (DateTime.now + 2.day).to_date, lunch_time: "2000-01-01 02:41:22", meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: "2000-01-01 03:41:22")
#    @user = users(:employee)
#  end
  
#  test 'should save host' do
#    host = @event.hosts.new(user_id: @user.id)
#    assert host.save
#  end
  
#  test 'should delete host' do
#    host_count = @event.hosts.count
#    host = @event.hosts.new(user_id: @user.id)
#    host.save
#    host.destroy
#    assert_equal host_count, @event.hosts.count    
#  end

#  test 'should increment host count' do
#    host_count = @event.hosts.count
#    host = @event.hosts.new(user_id: @user.id)
#    host.save
#    assert_equal host_count + 1, @event.hosts.count    
#  end

#  test "host should not save with out user_id" do
#    host = @event.hosts.new(user_id: nil)
#    assert_raises ActiveRecord::RecordInvalid do
#       host.save!
#    end
#  end

#  test 'host should not save with out lunchlearn_id' do 
#    host = Host.new(user_id: @user.id)
#    assert_raises ActiveRecord::RecordInvalid do
#       host.save!
#    end
#  end

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
