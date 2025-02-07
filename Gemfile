source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.7'

gem 'rails', '< 7.0'

gem 'bootsnap', require: false

gem 'appsignal'
gem 'csv'
gem 'dartsass-rails'
gem 'devise'
gem 'delayed_job_active_record'
gem 'drb'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'mutex_m'
gem 'pg', '< 1.5'
gem 'puma'
gem 'mail-notify'
gem 'notifications-ruby-client'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'textacular'
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
  gem 'foreman'
  gem 'listen'
  gem 'web-console'
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
