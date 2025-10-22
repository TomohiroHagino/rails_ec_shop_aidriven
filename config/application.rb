require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# DDD層のファイルを手動でロード（Zeitwerkより前に実行）
Dir[File.join(__dir__, '..', 'app', 'domain', '**', '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '..', 'app', 'application', '**', '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '..', 'app', 'infrastructure', '**', '*.rb')].sort.each { |f| require f }

module EcShopAidriven
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
