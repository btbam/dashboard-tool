module DashboardPlatform
  class Resources::Adjusters < Grape::API
    resource :adjusters do
      params do
        at_least_one_of :dashboard_manager_id, :adjuster_name
      end
      get do
        if params[:adjuster_name].present? && params[:adjuster_name] != 'Not Available'
          return [] if !can?(:read, Adjuster) || current_user.adjuster?
          adjuster_query = Adjuster.named_like(params[:adjuster_name]).with_open_features
          if current_user.dashboard_manager_id && current_user.manager?
            adjuster_query.where(
              adjuster_id: Adjuster.all_subordinates(current_user.dashboard_id)
            )
          elsif current_user.executive?
            adjuster_query
          else
            []
          end
        end
      end
    end
  end
end
