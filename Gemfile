source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails'

gem 'bootsnap', require: false

gem 'appsignal'
gem 'devise'
gem 'delayed_job_active_record'
gem 'jbuilder'
gem 'pg'
gem 'puma'
gem 'notifications-ruby-client'
gem 'textacular'
gem 'webpacker'
gem 'will_paginate'

group :development, :test do
  gem 'dotenv-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rubocop'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'faker'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-rubocop'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'pry'
  gem 'webdrivers'
  gem 'webmock'
end
