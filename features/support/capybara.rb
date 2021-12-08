Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[window-size=1280,960])

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless no-sandbox window-size=1280,960])

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
end

Capybara.javascript_driver = ENV.fetch("JS_DRIVER", "chrome_headless").to_sym
Capybara.automatic_label_click = true
Capybara.default_normalize_ws = true

Capybara.add_selector(:material) do
  xpath { |material| ".//tr/td[1][text()='#{material}']/parent::tr" }
end

Capybara.add_selector(:summary) do
  xpath { |heading| ".//h2[text()='#{heading}']/following-sibling::dl[1]" }
end
