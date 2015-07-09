source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test, :production]
gem 'pg'
# Heroku gems
group :staging do
  gem 'rails_12factor'

  gem 'unicorn'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'sass', '~> 3.2.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-timepicker-rails'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-sass'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use LDAP for authentication
gem 'net-ldap'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.2.1', group: :development
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-touch-linked-files'
gem 'capistrano-bundler'
# Use debugger
gem 'pry', group: [:development, :test]

# Use haml
gem 'haml-rails'

# iCalendar to generate Calendar Invites
gem 'icalendar'

gem 'coveralls', require: false

# httparty for calls to Bluesource api
gem 'httparty'

gem 'chosen-rails'
gem 'browser-timezone-rails'

# Paperclip for attaching files to eventsgem
gem 'paperclip', '~> 4.1'
gem 'delayed_job'
gem 'daemons'
gem 'delayed_paperclip'
gem 'delayed_job_active_record'

gem 'faker'
gem 'factory_girl_rails', '~> 4.0'

gem 'validates_timeliness'

gem 'capistrano-rvm'
gem "airbrussh", :require => false

gem 'aws-sdk', '< 2.0'
gem 's3_direct_upload'

gem 'whenever'
gem 'ruby-saml'

gem 'better_errors'
gem 'binding_of_caller'

gem 'webmock', group: :test
gem 'awesome_print'
