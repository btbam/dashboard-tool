class ApplicationController < ActionController::Base
  # check_authorization :unless => :devise_controller?

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: 500
  end

  before_action :detect_ie
  before_action :authenticate_user!

  def detect_ie
    return unless browser.ie? && request.env['PATH_INFO'] != '/upgrade'
    redirect_to '/upgrade'
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
