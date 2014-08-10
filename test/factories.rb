FactoryGirl.define do
  sequence :username do |n|
    "first.last#{n}"
  end

  factory :user do
    first_name 'john'
    last_name 'smith'
    username { generate(:username)}
    photo nil
    email 'john.smith@orasi.com'
    
    factory :admin_user do
      admin true
    end

    factory :normal_user do 
      admin false
    end

    factory :host_user do
      admin false
    end
  end

  factory :event do
    title 'some title'
    description 'this is a description of an event.  descriptions are not very long'
    
    after(:create) {|event| event.schedules.create(event_date: DateTime.now.to_date, event_time: DateTime.now.to_time, end_time: DateTime.now.to_time)}
    after(:create) {|event| event.hosts.create(user_id: create(:host_user).id)}
    factory :lunchlearnstyle do
      after(:build) {|event| event.build_event_style(element: Lunchlearn.find(create(:lunchlearn).id))}
    end

  end
 
  factory :lunchlearn do
    has_GoToMeeting true
    access_code '123-456-789'
    meeting_phone_number '(123)123-1234'
    go_to_meeting_url 'https://somecompany.com/meeting'
  end

end


