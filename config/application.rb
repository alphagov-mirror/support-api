require_relative "boot"

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SupportApi
  class Application < Rails::Application
    require "support_api"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.api_only = false

    # Disable Rack::Cache
    config.action_dispatch.rack_cache = nil

    config.active_record.schema_format = :sql

    config.after_initialize do
      config.action_mailer.notify_settings = { api_key: Rails.application.secrets.notify_api_key }
    end
  end
end
