module DashboardPlatform
  class Resources::ClosedFeatures < Grape::API
    resource :closed_features do
      params do
        requires :dashboard_compound_key, type: String
        requires :close_it, type: Boolean
      end
      post '', root: false do
        cf = ClosedFeature.find_or_initialize_by(user_id: current_user.id,
                                                 dashboard_compound_key: params[:dashboard_compound_key])
        Rails.cache.delete("feature/#{cf.dashboard_compound_key}")
        if params[:close_it]
          cf.save ? render(json: 'OK') : status(400)
        else
          if ClosedFeature.where(dashboard_compound_key: cf.dashboard_compound_key, user_id: cf.user_id).delete_all
            render(json: 'OK')
          else
            status(400)
          end
        end
      end
    end
  end
end
