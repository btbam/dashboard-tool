module DashboardPlatform
  class Resources::Users < Grape::API
    resource :users do
      get 'me' do
        current_user
      end

      post '', serializer: UserWithTokenSerializer do
        invite = InviteUser.new(current_user)

        user = invite.by_email(params[:email].upcase)

        if user
          user
        else
          status 400
        end
      end
    end
  end
end
