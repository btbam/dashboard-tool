# app/controllers/registrations_controller.rb
class ::Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def edit
    return redirect_to(root_path) if current_user.finished_registration
    super
  end

  def update
    params[:user][:login] = params[:user][:dashboard_lan_id]
    super
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).push(
      :name_first, :name_last, :dashboard_lan_domain, :dashboard_lan_id, :login, :finished_registration
    )
  end
end
