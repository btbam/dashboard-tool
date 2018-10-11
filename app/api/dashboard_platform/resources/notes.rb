module DashboardPlatform
  class Resources::Notes < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!('Record not found', 404)
    end

    resource :notes do
      params do
        requires :claim_id
      end
      get do
        feature = Feature.find_by(claim_id: params[:claim_id])
        return status(403) unless can?(:read, feature)
        cache_serialize("notes_#{params[:claim_id]}") do
          feature.notes.processed.displayable.order(dashboard_updated_at: :desc)
        end
      end
    end
  end
end
