require "capybara/rspec"

# Don't wait too long in `have_xyz` matchers
Capybara.default_max_wait_time = 2

# Normalizes whitespaces when using `has_text?` and similar matchers
Capybara.default_normalize_ws = true

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        "allow-insecure-localhost",
      ],
      w3c: false
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.register_driver :chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        "headless",
        "disable-gpu",
        "allow-insecure-localhost",
      ],
      w3c: false
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
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
