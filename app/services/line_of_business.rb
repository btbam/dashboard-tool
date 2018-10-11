require 'yaml'
require 'forwardable'

class LineOfBusiness
  class << self
    extend Forwardable
    def instance
      @instance ||= new
    end

    def_delegators :instance, :resque_config, :table_name_for, :business, :scoped_env
  end

  attr_reader :config

  def initialize
    default_lobfile = load_lobfile('default')
    environ_lobfile = ENV['MASTER_SERVER'] ? load_lobfile(Rails.env) : {}
    @config = default_lobfile.deep_merge(environ_lobfile)
  end

  def resque_config
    config['resque'] || []
  end

  def table_name_for(model)
    config.try(:[], 'tables').try(:[], model.name)
  end

  def scoped_env(key)
    scoped_key = "#{ENV['LINE_OF_BUSINESS'].upcase}_#{key.to_s.upcase}"
    if ENV.key?(scoped_key)
      ENV[scoped_key]
    else
      fail "environment variable #{scoped_key} does not exist"
    end
  end

  def business
    config['business']
  end

  private

  def load_lobfile(environment)
    path = File.join('config', 'lines_of_business', ENV['LINE_OF_BUSINESS'], "#{environment}.yml")
    begin
      YAML.load_file(path) || {}
    rescue
      {}
    end
  end
end
