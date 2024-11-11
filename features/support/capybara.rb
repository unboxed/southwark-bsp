Capybara.server = :puma, { Silent: true }
Capybara.server_port = 3443
Capybara.app_host = "http://southwark-bsp.localhost:3443"
Capybara.default_host = "http://southwark-bsp.localhost"

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--window-size=1280,960')
    opts.add_argument('--disable-dev-shm-usage')

    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument('--disable-site-isolation-trials')
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--window-size=1280,960')
    opts.add_argument('--disable-dev-shm-usage')

    if File.exist?("/.dockerenv")
      # Running as root inside Docker
      opts.add_argument('--no-sandbox')
      opts.add_argument('--disable-gpu')
    end

    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument('--disable-site-isolation-trials')
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
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
