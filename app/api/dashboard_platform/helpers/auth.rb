module DashboardPlatform
  module Helpers
    module Auth
      def warden
        env['warden']
      end

      def user_via_api
        api_headers = headers['X-Dashboard-Api-Key']
        User.find(api_headers) if !Rails.env.production? && api_headers
      end

      def current_user
        warden.user || user_via_api
      end

      def admin?
        current_user && current_user.is_admin?
      end

      def executive?
        current_user && current_user.executive?
      end

      # cancancan methods that get included in controllers
      def authorize!(*args)
        # you already implement current_user helper :)
        ::Ability.new(current_user).authorize!(*args)
      end

      def can?(*args)
        ::Ability.new(current_user).can?(*args)
      end
    end
  end
end
