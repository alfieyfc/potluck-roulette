# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Aws.config.update(
  endpoint: ENV['AWS_S3_ENDPOINT'],
  access_key_id: ENV['AWS_S3_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'],
  force_path_style: ENV['AWS_S3_FORCE_PATH_STYLE'],
  region: ENV['AWS_S3_REGION']
)

module Workspace
  # #TODO: Documentation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    config.autoload_paths += %W[#{config.root}/lib]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
