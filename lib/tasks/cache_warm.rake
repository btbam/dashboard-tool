$stdout.sync = true

namespace :cache do

  desc 'Warm all the caches'
  task :warm, [:port] => [:environment] do |t, args|
    Rails.application.eager_load!
    Rails.cache.clear

    dashboard_compound_keys = []
    dashboard_adjuster_ids = []

    users = User.active
    users.each do |user|
      if !dashboard_adjuster_ids.include?(user.dashboard_adjuster_id)
        dashboard_compound_keys += adjuster_features(user.dashboard_adjuster_id)
        dashboard_adjuster_ids << user.dashboard_adjuster_id
      end

      if !dashboard_adjuster_ids.include?(user.dashboard_manager_id)
        dashboard_compound_keys += adjuster_features(user.dashboard_manager_id)
        dashboard_adjuster_ids << user.dashboard_manager_id
      end
    end

    dashboard_compound_keys += executive_features.pluck(:dashboard_compound_key)

    warmer = CacheWarmer.new(dashboard_compound_keys: dashboard_compound_keys.uniq)
    warmer.run
  end

  def adjuster_features(dashboard_adjuster_or_manager_id)
    adjusters = Adjuster.all_subordinates(dashboard_adjuster_or_manager_id) << dashboard_adjuster_or_manager_id
    adjusters.in_groups_of(1000).inject([]) do |all_features, ids|
      all_features + Feature.open.with_created_date.for_api.select(:dashboard_compound_key).current_adjuster(ids).map do |feature|
        feature.dashboard_compound_key
      end
    end
  end

  def executive_features
    Feature.open.with_created_date.select(:dashboard_compound_key).limit(200)
  end
end
