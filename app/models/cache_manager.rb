class CacheManager
  def self.default_expires
    expires_at(Time.zone.tomorrow + 7.hours + 30.minutes)
  end

  def self.expires_at(datetime)
    (datetime - Time.zone.now).to_i
  end

  def self.default_cache_race_ttl
    10
  end

  def self.caching_namespace
    "claim-us-#{ENV['CACHING_NAMESPACE_KEY']}"
  end

  def self.cache_config
    { expires_in: default_expires, race_condition_ttl: default_cache_race_ttl, namespace: caching_namespace }
  end

  # cache the result of the block using the specified key
  def self.cache(key, &block)
    fail 'Block required!' unless block_given?
    Rails.cache.fetch(key, cache_config, &block)
  end

  # serialize the result of the block using the specified serializer
  def self.serialize(serializer: ActiveModel::ArraySerializer, json_opts: {})
    fail 'Block required!' unless block_given?
    serializer.new(yield).as_json(json_opts)
  end

  # serialize the result of the block using the specified serializer, and cache with the specified key
  def self.cache_serialize(key, serializer: ActiveModel::ArraySerializer, json_opts: {}, &block)
    cache(key) { serialize(serializer: serializer, json_opts: json_opts, &block) }
  end

  def self.adjuster_ids_for_manager(manager_id)
    cache("adjuster_ids_for_manager_#{manager_id}") do
      Adjuster.manager(manager_id).pluck(:adjuster_id).uniq
    end
  end
end
