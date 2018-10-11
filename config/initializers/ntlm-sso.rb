require 'rack'
require 'rack/auth/ntlm-sso'
require 'rack/auth/digest/md5'
require 'continuation'

class NTLMAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    req_env = req.env
    remote_user = req_env['REMOTE_USER']
    re = Regexp.new(/windows/i)

    env = callcc do |cont|
      if re.match(req_env['HTTP_USER_AGENT']) && remote_user && !remote_user.empty?
        auth = Rack::Auth::NTLMSSO.new(cont)
        # optional configuration
        #auth.domain = "MYDOMAIN"
        auth.default_remote_user = "INVALID"
      else
        auth = Rack::Auth::Digest::MD5.new(cont)
      end

      begin
        return auth.call(env)
      rescue
        env
      end
    end

    @app.call(env)
  end
end
