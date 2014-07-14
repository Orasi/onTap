# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['all', Rails.env].each do |seed|
  seed_file ="#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts"*** Loading #{seed} seed data"
    require seed_file
  end
end

