module DashboardPlatform
  module Helpers
    module Cache
      def cache_feature(feature)
        cache_serialize(
          "feature/#{feature.dashboard_compound_key}",
          serializer: FeatureSerializer,
          json_opts: { root: false }
        ) do
          feature
        end
      end

      def cache_compound_key(compound_key)
        cache_serialize(
          "feature/#{compound_key}",
          serializer: FeatureSerializer,
          json_opts: { root: false }
        ) do
          Feature.where(dashboard_compound_key: compound_key).for_warming.first
        end
      end

      def default_expires
        expires_at(Time.zone.tomorrow + 7.hours + 30.minutes)
      end

      def expires_at(datetime)
        (datetime - Time.zone.now).to_i
      end

      def default_cache_race_ttl
        10
      end

      def caching_namespace
        "claim-us-#{ENV['CACHING_NAMESPACE_KEY']}"
      end

      def cache_config
        { expires_in: default_expires, race_condition_ttl: default_cache_race_ttl, namespace: caching_namespace }
      end

      # cache the result of the block using the specified key
      def cache(key, &block)
        fail 'Block required!' unless block_given?
        Rails.cache.fetch(key, cache_config, &block)
      end

      # serialize the result of the block using the specified serializer
      def serialize(serializer: ActiveModel::ArraySerializer, json_opts: {})
        fail 'Block required!' unless block_given?
        serializer.new(yield).as_json(json_opts)
      end

      # serialize the result of the block using the specified serializer, and cache with the specified key
      def cache_serialize(key, serializer: ActiveModel::ArraySerializer, json_opts: {}, &block)
        cache(key) { serialize(serializer: serializer, json_opts: json_opts, &block) }
      end
    end
  end
end
