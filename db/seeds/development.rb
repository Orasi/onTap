User.create(username: 'matt.watson', first_name: 'matt', last_name: 'watson', admin: true, photo: nil, email: 'matt.watson@orasi.com')
User.create(username: 'kevin.munro', first_name: 'kevin', last_name: 'munro', admin: true, photo: nil, email: 'kevin.munro@orasi.com')
User.create(username: 'lewis.gordon', first_name: 'lewis', last_name: 'gordon', admin: true, photo: nil, email: 'lewis.gordon@orasi.com')
User.create(username: 'company.admin', first_name: 'company', last_name: 'admin', admin: true, photo: nil, email: 'company.admin@orasi.com')
100.times do
  names = Faker::Name.name
  name_array = names.split
  first_names = name_array[0]
  last_names = name_array[1]
  usernames = first_names + '.' + last_names
  User.create(username: usernames, first_name: first_names, last_name: last_names, email: usernames + '@orasi.com', admin: false, photo: nil,)
end

event_types = %w(lunch_and_learn webinar)
40.times do
  random_start = rand(-1.years..1.years).ago
  while random_start.hour > 16
    random_start = rand(-1.years..1.years).ago
  end
  random_end = random_start + rand(1..5).hours
  e = Event.new(title: Faker::Name.title, description:   Faker::Hacker.say_something_smart)
  if e.save
    s = e.schedules.new(start: random_start, end: random_end)
    unless s.save
      print s.errors.full_messages
      print random_start.to_s
      print random_end.to_s
    end
  end
  style = event_types[rand(0..(event_types.count - 1))]
  if style == 'lunch_and_learn'
    has_meeting = [true, false].sample
    if has_meeting
      type = Lunchlearn.create(has_GoToMeeting: has_meeting, meeting_phone_number: '(' + rand(100..999).to_s + ')' + rand(100..999).to_s + '-' + rand(1000..9999).to_s, access_code: rand(100..999).to_s + '-' + rand(100..999).to_s + '-' + rand(100..999).to_s, go_to_meeting_url: Faker::Internet.url)
    else
      type = Lunchlearn.create(has_GoToMeeting: has_meeting)
    end
  elsif style == 'webinar'
    type = Webinar.create(url: Faker::Internet.url)
  elsif style == 'training_class'
    type = TrainingClass.create
  end
  es = e.build_event_style(element: type)
  es.save
end

Event.all.each do |l|
  rand(1..3).times do
    user_id = rand(1..User.all.count)
    unless l.hosting_event?(User.find(user_id))
      l.hosts.create(user_id: user_id)
    end
  end

  rand(5..20).times do
    user_id = rand(1..User.all.count)
    unless l.attending_event?(User.find(user_id))
      a =l.attendees.create(user_id: rand(1..User.all.count))
      if l.past?
        a.update(status: %w(attended noshow).sample)
      end
    end
  end

  if l.past?
    l.update(status: 'finalized')
  end
end
