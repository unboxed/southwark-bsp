require_relative 'boot'

require 'rails'

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SouthwarkBsp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Europe/London"

    config.action_mailer.delivery_method = :notify
    config.action_mailer.notify_settings = { api_key: ENV.fetch("NOTIFY_API_KEY") }
    config.action_view.form_with_generates_remote_forms = false
    config.action_view.field_error_proc = ->(html_tag, instance) { html_tag }
    config.action_view.prefix_partial_path_with_controller_namespace = false
    config.active_job.queue_adapter = :delayed_job
  end
end
