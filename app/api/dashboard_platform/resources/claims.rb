module DashboardPlatform
  class Resources::Claims < Grape::API
    resource :claims do
      helpers do
        def all_ids_for_manager(manager_id)
          cache("all_ids_for_manager_#{manager_id}") do
            Adjuster.all_subordinates(manager_id) << manager_id
          end
        end

        def features
          (params[:closed] ? Feature.closed : Feature.open).with_created_date.for_api
        end

        def claims_for_adjuster_id
          return status(403) unless can?(:read, :claims_adjuster_api)
          adjusters = all_ids_for_manager(params[:dashboard_adjuster_id])
          adjusters.in_groups_of(1000).inject([]) do |all_features, ids|
            all_features + features.select(:dashboard_compound_key).current_adjuster(ids).map do |feature|
              cache_compound_key(feature.dashboard_compound_key)
            end
          end
        end

        def claims_all
          return status(403) unless can?(:read, :features)
          features.select(:dashboard_compound_key).limit(200).map do |feature|
            cache_compound_key(feature.dashboard_compound_key)
          end
        end
      end

      desc 'Get Features (aka claims)'
      params do
        mutually_exclusive :dashboard_adjuster_id, :dashboard_manager_id
        optional :closed
      end
      get do
        claims = if params[:dashboard_adjuster_id] || params[:dashboard_manager_id] # Get claims for adjuster or manager
                   params[:dashboard_adjuster_id] ||= params[:dashboard_manager_id]
                   claims_for_adjuster_id
                 elsif current_user.adjuster? || current_user.manager?
                   params[:dashboard_adjuster_id] =
                     current_user.adjuster? ? current_user.dashboard_adjuster_id : current_user.dashboard_manager_id
                   claims_for_adjuster_id
                 elsif current_user.executive? # Not an adjuster search b/c no params
                   claims_all
                 else
                   []
                 end
        claims
      end

      route_param :id do
        get serializer: FeatureWithDiarySerializer do
          Feature.find(params[:id])
        end

        get :detail do
          diary_notes = DiaryNote.by_dashboard_compound_key(params[:id]).displayable.order(updated_at: :desc)
          feature = Feature.find_by(dashboard_compound_key: params[:id])
          notes = feature
                  .notes.select("id,
                                 author_type,
                                 message,
                                 note_title,
                                 dashboard_updated_at as updated_at,
                                 dashboard_updated_at,
                                 author_id")
                  .processed
                  .displayable
                  .order(dashboard_updated_at: :desc)
          details = (diary_notes + notes).sort_by(&:updated_at).reverse
          details.map do |detail|
            if %w(DiaryNote Note).include?(detail.class.name)
              (detail.class.name + 'DetailSerializer').constantize.send(:new, detail)
            end
          end
        end
      end
    end
  end
end
