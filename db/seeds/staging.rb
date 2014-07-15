User.create(username: "matt.watson", first_name: "matt", last_name: "watson", admin: true, photo: nil, email: "matt.watson@orasi.com")
User.create(username: "kevin.munro", first_name: "kevin", last_name: "munro", admin: true, photo: nil, email: "kevin.munro@orasi.com")
User.create(username: "lewis.gordon", first_name: "lewis", last_name: "gordon", admin: true, photo: nil, email: "lewis.gordon@orasi.com")
User.create(username: "company.admin", first_name: "company", last_name: "admin", admin: true, photo: nil, email: "company.admin@orasi.com")
100.times do
  names = Faker::Name.name
  name_array = names.split
  first_names = name_array[0]
  last_names = name_array[1]
  usernames = first_names + "." +last_names
  User.create(username: usernames, first_name: first_names, last_name: last_names, email: usernames + "@orasi.com", admin: false, photo: nil,)
end


40.times do 
  random_start = rand(-1.years..1.years).ago
  random_end = random_start + rand(1..5).hours
  Lunchlearn.create( title: Faker::Name.title, description:   Faker::Hacker.say_something_smart, lunch_date: random_start.to_date, lunch_time: random_start.to_time, meeting_phone_number: "", access_code: "", has_GoToMeeting: false, go_to_meeting_url: "", end_time: random_end.to_time)


end

Lunchlearn.all.each do |l|
  rand(1..3).times do
    l.hosts.create(user_id: rand(1..User.all.count))
  end

    rand(5..20).times do
      l.attendees.create(user_id: rand(1..User.all.count))
    end


end
