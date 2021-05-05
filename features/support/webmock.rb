require "webmock/cucumber"

allowed_hosts = ["chromedriver.storage.googleapis.com"]
WebMock.disable_net_connect! allow_localhost: true, allow: allowed_hosts

Before do
  url = "https://api.notifications.service.gov.uk/v2/notifications/letter"

  response = {
    status: 200,
    body: "{}",
    headers: {
      "Content-Type" => "application/json"
    }
  }

  stub_request(:post, url).to_return(response)
end
