require "webmock/rspec"

allowed_hosts = ["chromedriver.storage.googleapis.com"]
WebMock.disable_net_connect! allow_localhost: true, allowed: allowed_hosts
