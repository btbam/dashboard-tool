module DashboardPlatform
  class Resources::FeatureDates < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!('Record not found', 404)
    end

    helpers do
      def change_feature_date(feature, role_name)
        feature_date = FeatureDate.find_or_initialize_by(
          dashboard_compound_key: feature.dashboard_compound_key, role_name: role_name
        )

        if can?(:update, feature_date)
          due = params[:due]
          feature_date.due = due if due
          feature_date.save
          Rails.cache.delete("feature/#{feature_date.dashboard_compound_key}")
        end
        feature_date
      end
    end

    resource :feature_dates do
      put ':dashboard_compound_key' do
        feature_dates = []
        role_name = current_user.adjuster? ? 'adjuster' : 'manager'

        feature = Feature.where(dashboard_compound_key: params[:dashboard_compound_key].to_s).first

        if feature && params[:all]
          Feature.where(claim_id: feature.claim_id).open.each do |f|
            feature_date = change_feature_date(f, role_name)
            feature_dates.push(feature_date)
          end
        elsif feature
          feature_date = change_feature_date(feature, role_name)
          feature_dates.push(feature_date)
        end
        feature_dates
      end
    end
  end
end
