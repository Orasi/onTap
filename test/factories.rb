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

    after(:create) do |user|
      @profile=user.build_profile(food_pref: 'None', location: 'Other', notification_settings: true)
      @profile.save
    end
  end

  # **************  EVENT FACTORIES **********************

  factory :event do
    title 'some title'
    description 'this is a description of an event.  descriptions are not very long'

    after(:create) do |event|
      event.schedules.create(start: DateTime.now, 'end' => DateTime.now+ 3.hours)

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

    factory :trainingclassstyle do
      after(:build) { |event| event.build_event_style(element: TrainingClass.find(create(:trainingclass).id)) }
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

  factory :trainingclass, :class => 'TrainingClass' do
    has_GoToMeeting true
    access_code '987-654-321'
    meeting_phone_number '(195)195-1951'
    go_to_meeting_url 'https://atrainingclass.com/meeting'
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

    trait :no_status do
     after(:build) do |notification|
       notification.update(status: nil)
     end
    end

    trait :wrong_status do
      after(:build) do |notification|
        notification.update(status: 'not valid status')
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
    trait :no_type do
      after(:build) do |notification|
        notification.update(notification_type: nil)
      end
    end
    trait :invalid_type do
      after(:build) do |notification|
        notification.update(notification_type: 'whats this doing here?')
      end
    end

    trait :old do
      after(:create) do |notification|
        notification.update(created_at: DateTime.now - 10.days)
      end
    end
  end

  # ***********************Profile Factory **************************
  factory :profile do
    food_pref 'None'
    location 'Other'
    notification_settings true

    trait :other do
      after(:build) do |profile|
        profile.update(food_pref: 'I only eat hotdogs')
      end
    end
  end

  # ***********************Referral Factory **************************
  factory :referral do
    refer_email 'test.test@orasi.com'
    refer_message 'some message'
    refer_sender_id 1
    refer_event_id 1
  end

  trait :multiple do
    after(:build) do |refer|
      refer.update(refer_email: 'test1.test1@orasi.com, test2.test2@orasi.com')
    end
  end

  trait :non_orasi do
    after(:build) do |refer|
      refer.update(refer_email: 'nogood@wrong.com')
    end
  end

  trait :worse do
    after(:build) do |refer|
      refer.update(refer_email: 'nogood@wrong')
    end
  end

  trait :worst do
    after(:build) do |refer|
      refer.update(refer_email: 'what?')
    end
  end
end
