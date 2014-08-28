require 'test_helper'

class EventsHelperTest < ActionView::TestCase
  test 'should return requests' do
    event = FactoryGirl.create(:lunchlearnstyle)
    user = FactoryGirl.create(:normal_user)
    request = Request.create(user_id: user.id, event_id: event.id)
    session[current_user_id: user.id]
    assert_not_nil check_for_requests
  end
end
