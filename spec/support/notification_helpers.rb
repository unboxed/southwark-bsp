module NotificationHelpers
  def stub_notify_response
    stub_request(
      :post,
      "https://api.notifications.service.gov.uk/v2/notifications/email"
    ).to_return(status: 200, body: response_body)
  end

  def response_body
    {
      id: SecureRandom.uuid,
      uri: "http://someplace.fun/1"
    }.to_json
  end
end
