require "capybara/rspec"

# Don't wait too long in `have_xyz` matchers
Capybara.default_max_wait_time = 2

# Normalizes whitespaces when using `has_text?` and similar matchers
Capybara.default_normalize_ws = true

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[allow-insecure-localhost])

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu allow-insecure-localhost])

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :chrome_headless
  end

  config.before(:each, type: :system, js: true, headless: false) do
    driven_by :chrome
  end
end
