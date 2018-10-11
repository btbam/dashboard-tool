module DashboardAlerts
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    resource :alerts do
      get do
        Alert.displayable
      end
    end
  end
end
