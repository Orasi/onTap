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
      event.schedules.create(start: DateTime.now, 'end' => DateTime.now )

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
        s.update_attribute(:start, (DateTime.now - 5.days))
	s.update_attribute('end', (DateTime.now - 5.days))
      end
    end
  end

  trait :future do
    after(:create) do |event|
      event.schedules.each do |s|
        s.update_attribute(:start, (DateTime.now + 5.days))
	s.update_attribute('end', (DateTime.now + 5.days))
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

  # ***********************Surveys Factory **************************
  factory :survey do
    went_well 'something went well'
    improved 'something could be improved on'
    host_knowledge 5
    host_presentation 5
    effect 'effect work in some way'
    extra 'some extra response'
    after(:build) { |survey| survey.user_id = create(:normal_user).id }
    after(:build) { |survey| survey.event_id = create(:lunchlearnstyle, :restricted).id }
  end

  # ***********************Notifications Factory **************************
  factory :notification do
    status 'new'
    notification_type 'attendance'
    after(:build) { |notification| notification.user_id = create(:normal_user).id }
    after(:build) { |notification| notification.manager_id = create(:host_user).id }
    after(:build) { |notification| notification.event_id = create(:lunchlearnstyle, :restricted).id }

    trait :new do
      after(:create) do |notification|
        notification.update_attribute(:status, 'new')
      end
    end

    trait :approved do
      after(:create) do |notification|
        notification.update_attribute(:status, 'approved')
      end
    end

    trait :rejected do
      after(:create) do |notification|
        notification.update_attribute(:status, 'rejected')
      end
    end

    trait :surveynotification do
      after(:create) do |notification|
        notification.update_attribute(:notification_type, 'survey')
      end
    end

    trait :attendancenotification do
      after(:create) do |notification|
        notification.update_attribute(:notification_type, 'attendance')
      end
    end

  end
end
