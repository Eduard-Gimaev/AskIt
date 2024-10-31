require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskIt
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.available_locales = [ :en, :ru, :es, :ar ]
    config.i18n.default_locale = :en
    config.time_zone = "Madrid"
    # config.eager_load_paths << Rails.root.join("extras")

    # Ensure the asset pipeline is enabled and configured
    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
    config.assets.precompile += %w[ application.scss ]
    config.active_job.queue_adapter = :sidekiq
  end
end
