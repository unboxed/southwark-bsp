module Callbacks
  class CallbacksController < ApplicationController
    before_action :authenticate_callback

    protected

      def authenticate_callback
        authenticate_or_request_with_http_token do |token, _|
          ActiveSupport::SecurityUtils.secure_compare token, ENV.fetch("NOTIFY_CALLBACK_TOKEN")
        end
      end
  end
end
