require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'dotenv'

env_specific_dotenv = File.join(Dir.pwd, 'config', 'dotenv', ".env.#{Rails.env}")
dotenv_files = [
  (File.exists?(env_specific_dotenv) ? env_specific_dotenv : nil),
  File.join(Dir.pwd, 'config', 'dotenv', '.env')
].compact

Dotenv.load(*dotenv_files)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if File.exists?(File.expand_path('../app.yml', __FILE__))
  config = YAML.load(File.read(File.expand_path('../app.yml', __FILE__)))
  config.merge! config.fetch(Rails.env, {})
  config.each do |key, value|
    ENV[key] ||= value.to_s unless value.kind_of? Hash
  end
end

OCI8::BindType::Mapping[Time] = OCI8::BindType::LocalTime
OCI8::BindType::Mapping[:date] = OCI8::BindType::LocalTime
OCI8::BindType::Mapping[:timestamp] = OCI8::BindType::LocalTime
OCI8::BindType::Mapping[:timestamp_ltz] = OCI8::BindType::LocalTime

module DashboardTool
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W["#{config.root}/app/validators/"]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = ENV["APP_TIMEZONE"] if ENV["APP_TIMEZONE"]
    config.middleware.use "NTLMAuthentication"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
