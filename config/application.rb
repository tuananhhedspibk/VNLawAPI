require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VNLaw
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.middleware.use Rack::Attack

    config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    
    config.i18n.default_locale = :vn
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "localhost:3000"
        resource "*",
        headers: :any,
        methods: %i(get post put patch delete options head)
      end
    end
  end
end
