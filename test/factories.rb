require 'date'
FactoryGirl.define do
  sequence :username do |n|
    "first.last#{n}"
  end

  # **************  USER FACTORY ***********************

  factory :user do
    first_name 'john'
    last_name 'smith'
    username { generate(:username) }
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

  # **************  EVENT FACTORIES **********************

  factory :event do
    title 'some title'
    description 'this is a description of an event.  descriptions are not very long'

    after(:create) do |event|
      event.schedules.create(event_date: DateTime.now.to_date, event_time: DateTime.now.to_time, end_time: DateTime.now.to_time)

      [1, 2, 3].sample.times do
        event.hosts.create(user_id: create(:host_user).id)
      end

      rand(5..20).times do
        event.attendees.create(user_id: create(:normal_user).id)
      end
    end

    factory :lunchlearnstyle do
      after(:build) { |event| event.build_event_style(element: Lunchlearn.find(create(:lunchlearn).id)) }
    end

    factory :webinarstyle do
      after(:build) { |event| event.build_event_style(element: Webinar.find(create(:webinar).id)) }
    end

  end
  trait :past do
    after(:create) do |event|
      event.schedules.each do |s|
        s.update_attribute(:event_date, (Date.today - 5))
      end
    end
  end

  trait :future do
    after(:create) do |event|
      event.schedules.each do |s|
        s.update_attribute(:event_date, (Date.today + 5))
      end
    end
  end

  trait :finalized do
    status 'finalized'
  end

  trait :restricted do
    restricted true
  end

  factory :lunchlearn do
    has_GoToMeeting true
    access_code '123-456-789'
    meeting_phone_number '(123)123-1234'
    go_to_meeting_url 'https://somecompany.com/meeting'
  end

  factory :webinar do
    url 'https://www.google.com'
  end
  # ***********************Suggestion Factory **************************
  factory :suggestion do
    suggestion_title 'some suggestion title'
    suggestion_description 'some suggestion description'
    after(:build) { |suggestion| suggestion.user_id = create(:normal_user).id }
  end


end
