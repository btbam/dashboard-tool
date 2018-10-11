module DashboardPlatform
  class API < Grape::API
    version 'v1', using: :header, vendor: 'dashboard'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    helpers DashboardPlatform::Helpers::Auth
    helpers DashboardPlatform::Helpers::Cache

    mount DashboardPlatform::Resources::Config
    mount DashboardPlatform::Resources::Users
    mount DashboardPlatform::Resources::Adjusters
    mount DashboardPlatform::Resources::Claims
    mount DashboardPlatform::Resources::Feedbacks
    mount DashboardPlatform::Resources::DiaryNotes
    mount DashboardPlatform::Resources::Notes
    mount DashboardPlatform::Resources::FeatureDates
    mount DashboardPlatform::Resources::ClosedFeatures
    mount DashboardPlatform::Resources::HiddenColumns
  end
end
