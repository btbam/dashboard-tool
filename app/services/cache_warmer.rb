require 'ostruct'
require 'forwardable'
require 'set'
require 'etl'
include DashboardPlatform::Helpers::Cache

class CacheWarmer
  extend Forwardable

  # forward some messages to @options
  def_delegators :@options

  attr_accessor :options, :logger, :thread_pool, :benchmark_times, :dashboard_compound_keys,
                :dashboard_compound_keys_slice, :batch_limit, :total_features

  def initialize(**opts)
    @options = OpenStruct.new(option_defaults.merge(opts))
    @logger = Logger.new(STDOUT)
    logger_formatter
    @thread_pool = ::ETL::ThreadPool.new(options.thread_pool_count)
    @dashboard_compound_keys = options.dashboard_compound_keys
    @dashboard_compound_keys_slice = @benchmark_times = []
  end

  # default values for options, with explanations
  def option_defaults
    {
      # An array of all the dashboard_compound_keys to cache
      dashboard_compound_keys: [],
      # The number of threads to use to cache the features
      # thread_pool_count: Rails.env.development? ? 5 : 50
      thread_pool_count: 5
    }
  end

  def run
    total_time = Benchmark.realtime do
      log_cache_warmer_start
      (0..total_features).step(batch_limit) do |limit|
        thread_pool.schedule do
          warm_cache(limit)
        end
        sleep(1)
      end
      thread_pool.shutdown
      log_cache_warmer_finish
    end
    logger.info "total_time = #{total_time}"
  end

  private

  def log_cache_warmer_start
    logger.info("Total Features: #{total_features}")
    logger.info "Batch Size: #{batch_limit}"
  end

  def batch_limit
    @batch_limit ||= 700
  end

  def total_features
    @total_features ||= dashboard_compound_keys.count
  end

  def warm_cache(limit)
    warm_time = Benchmark.realtime do
      dashboard_compound_keys_this_thread(limit)
      features = Feature.for_warming.where(dashboard_compound_key: Thread.current[:dashboard_compound_keys_slice])
      warm_features(features)
    end
    benchmark_times << warm_time
    logger.info "Slice: #{limit}/#{total_features} Time: #{warm_time}"
  end

  def warm_features(features)
    features.each do |feature|
      cache_time = Benchmark.realtime do
        cache_feature(feature)
      end
      logger.info "Cache #{feature.dashboard_compound_key} in: #{cache_time}"
    end
  end

  def dashboard_compound_keys_this_thread(limit)
    Thread.current[:dashboard_compound_keys_slice] = dashboard_compound_keys[limit, batch_limit]
    logger.info "Dashboard Compound Keys Slice Size = #{Thread.current[:dashboard_compound_keys_slice].size}"
  end

  def logger_formatter
    @logger.formatter ||= proc do |severity, datetime, _progname, msg|
      thread_id = Thread.current[:id]
      thread_stamp = thread_id ? "(#{thread_id})" : '(M)'
      "[#{datetime.strftime('%D %T.%6N')}] #{severity} #{thread_stamp} : #{msg}\n"
    end
  end

  def log_cache_warmer_finish
    logger.info "@benchmark_times: #{@benchmark_times.sort}"
    ImporterRun.create(id: ImporterRun.next_id,
                       source_model: ENV['IP'],
                       destination_model: 'cache:warm',
                       completed_at: Time.zone.now)
  end
end
