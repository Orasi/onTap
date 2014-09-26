namespace :events do
  desc "Rake task to get events data"
  task :fetch => :environment do
    events = Event.nba_search
    events.each do |item|
      item.each do |hash|
        @event = Event.new({
        # Code to instantiate an event
        })
        @event.save
      end
    end
    puts "#{Time.now} - Success!"
  end
end
