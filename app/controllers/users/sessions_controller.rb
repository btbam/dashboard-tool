class ::Users::SessionsController < ::Devise::SessionsController
  before_action :configure_permitted_parameters

  layout 'application'

  def activate
    redirect_to '/'
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def new
    # only accept NTLM from Windows clients
    # Firefox on Windows respects the NTLM trusted URIs
    user_agent = request.env['HTTP_USER_AGENT']
    re = Regexp.new(/windows/i)

    if re.match(user_agent) && request.env['REMOTE_USER'] && !request.env['REMOTE_USER'].empty?
      user_string = request.env['REMOTE_USER']
    end
    if user_string && user_string != 'INVALID'
      users = User.where('lower(dashboard_lan_id) = ?', user_string.downcase)
      user = users.first if users.any?
      if user
        sign_in user
        redirect_to root_url
        return
      end
    end

    super
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

  def create
    begin
      resp = client.call(:auth_using_r1_lan_id, message: message)
    rescue Savon::SOAPFault => e
      e
    end

    if resp && resp.body[:lan_id_auth_response][:authentication_status] == '1'
      user = User.find_by('lower(dashboard_lan_id) = ?', username.downcase)
      if user
        sign_in user
      else
        redirect_to(new_user_session_path,
                    alert: "We couldn't find your account. Please ask someone to create it for you.")
        return
      end
    end

    super
  end

  def destroy
    redirect_path = after_sign_out_path_for(current_user)
    reset_session
    set_flash_message :notice, :signed_out
    yield resource if block_given?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  protected

  def username
    @username ||= params[:user][:dashboard_lan_id]
  end

  def password
    @password ||= params[:user][:password]
  end

  def namespaces
    @namespaces ||= { 'xmlns:cas' => 'http://CASLExtBasicDataType' }
  end

  def message
    @message ||= { 'lanIdAuthRequest' => { 'cas:LanId' => username, 'cas:Password' => password } }
  end

  def client
    @client ||= Savon.client(wsdl: 'https://caslsvc-qa.dashboard.net:15021/CASLServicesWeb/services/CASLExtConsumingServicesPort/wsdl/CASLExtConsumingServicesV7.wsdl',
                             ssl_ca_cert_file: 'casl_ws.pem',
                             ssl_verify_mode: :none,
                             ssl_version: :TLSv1,
                             convert_request_keys_to: :camelcase,
                             logger: Rails.logger,
                             log: true,
                             log_level: :debug,
                             env_namespace: :soapenv,
                             namespaces: namespaces,
                             no_message_tag: true,
                             filters: [:Password])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in).push(:email)
  end
end
