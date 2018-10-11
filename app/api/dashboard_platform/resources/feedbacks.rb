module DashboardPlatform
  class Resources::Feedbacks < Grape::API
    resource :feedbacks do
      post do
        feedback = Feedback.create(
          note: params[:note],
          feature_id: params[:feature_id],
          user_id: current_user.id
        )
        return status(400) unless feedback.persisted?
      end
    end
  end
end
