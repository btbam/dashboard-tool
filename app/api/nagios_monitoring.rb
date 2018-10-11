class NagiosMonitoring < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  http_basic do |user, password|
    user = ENV['MONITORING_USER']
    password = ENV['MONITORING_PASS']
  end

  helpers do
    def generate_alerts(ips)
      [].tap do |alerts|
        ips.each do |ip|
          na = OpenStruct.new(ip: ip, alerts: ['cache']).tap do |object|
            object.define_singleton_method :read_attribute_for_serialization do |attr|
              send(attr)
            end
          end

          # Importer and processor only run on this server
          na.alerts.push('import', 'processing') if ip == '127.0.0.1'
          alerts << na
        end
      end
    end
  end

  get 'importers', root: false, each_serializer: NagiosAlertSerializer do
    # Get distinct ips if not supplied
    ips = ImporterRun.nagios_alerts.map(&:source_model)
    generate_alerts(ips)
  end

  get 'importers/*ip', root: false, serializer: NagiosAlertSerializer do
    if ImporterRun.where(source_model: params[:ip]).count > 0
      generate_alerts([params[:ip]]).first
    else
      error!('Not Found', 404)
    end
  end
end
