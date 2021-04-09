helpers = Module.new do
  def set_session_id(id)
    env = Rack::MockRequest.env_for("/", Rails.application.env_config)
    req = ActionDispatch::Request.new(env)
    jar = ActionDispatch::Cookies::CookieJar.build(req, {})
    key = Rails.configuration.session_options[:key]

    jar.encrypted[key] = { value: { "session_id" => id } }
    page.driver.browser.set_cookie("#{key}=#{Rack::Utils.escape(jar[key])}")
  end
end

World(helpers)
