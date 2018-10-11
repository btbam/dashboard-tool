require 'rake'
Rake::Task.clear
Rails.application.load_tasks

class ScheduledCacheWarm
  @queue = :high

  def self.perform
    if ENV['MASTER_SERVER']
      # etl_env = case Rails.env
      #           when 'staging'
      #             'test'
      #           when 'production'
      #             'live'
      #           else
      #             'dev'
      #           end
      # # Trigger the ETL on the SASS server over SSH
      # `sshpass -p "#{ENV['ETL_PASSWORD']}" ssh -o StrictHostKeyChecking=no #{ENV['ETL_USERNAME']}@#{ENV['ETL_HOST']} 'cd /SASHome/ccu04/dashboard/etl/dashboard-#{etl_env}/scripts && ./submit-sandbox'`

      results = ImporterRun.check_start_cache_warm
      limit = 0
      while(results.size < 2 && limit <= 360) do
        sleep(60)
        limit += 1
        results = ImporterRun.check_start_cache_warm
      end

      # # Clear the cache and re-import on the other server
      # # Background it so it doesn't hang while processing
      # `sudo chmod 600 #{Rails.root.to_s}/vagrant/warm_key`
      # `ssh -i #{Rails.root.to_s}/vagrant/warm_key vagrant@127.0.0.1 'cd #{Rails.root.to_s} && RAILS_ENV=#{Rails.env} bundle exec rake cache:warm > log/cache_warm.log 2>&1 &'`

      # Clear the cache and re-import on this server
      Rake::Task['cache:warm'].invoke()
    end
  end
end
