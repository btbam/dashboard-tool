module DashboardPlatform
  class Resources::Stars < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!('Record not found', 404)
    end

    resource :stars do
      get do
        current_user.stars
      end

      post do
        return status(403) unless can?(:create, Star)
        star = Star.create(
          feature_id: params[:feature_id],
          user_id: current_user.id
        )
        return status(400) unless star.persisted?
        star
      end

      delete ':id' do
        star = Star.find(params[:id])
        return status(403) unless can?(:destroy, star)
        star.destroy
      end
    end
  end
end
