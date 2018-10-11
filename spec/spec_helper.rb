# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'simplecov'

SimpleCov.start do
  coverage_dir File.join(File.dirname(__FILE__), '..', 'public', 'coverage')
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::DataHelper, type: :feature
  config.include Features::PoltergeistHelper, type: :feature

  config.infer_spec_type_from_file_location!
end
