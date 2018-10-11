require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

Phantomjs.path # Force install on require
puts Phantomjs.path
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    phantomjs: Phantomjs.path,
    timeout: 10_000,
    window_size: [1600, 1200])
end

Capybara.default_max_wait_time = 10

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include Capybara::Angular::DSL, type: :feature
end
