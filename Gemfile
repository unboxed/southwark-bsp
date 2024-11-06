source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.6'

gem 'rails', '< 7.0'

gem 'bootsnap', require: false

gem 'appsignal'
gem 'devise'
gem 'delayed_job_active_record'
gem 'jbuilder'
gem 'pg', '< 1.5'
gem 'puma'
gem 'notifications-ruby-client'
gem 'textacular'
gem 'webpacker'
gem 'will_paginate'
gem 'statesman'

group :development, :test do
  gem 'dotenv-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :development do
  gem 'web-console'
  gem 'listen'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'pry'
  gem 'timecop'
  gem 'webmock'
end
