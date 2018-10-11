module DashboardPlatform
  class Resources::Config < Grape::API
    resource :config do
      get do
        { flags_visible: ActiveRecord::ConnectionAdapters::Column.value_to_boolean(ENV['FLAGS_VISIBLE']) }
      end
    end
  end
end
