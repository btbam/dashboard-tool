module RailsAdmin
  module Config
    module Actions
      class SignupLink < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :link_icon do
          'icon-envelope'
        end

        register_instance_option :member do
          true
        end

        register_instance_option :visible? do
          bindings[:abstract_model].model.to_s == 'User'
        end
      end
    end
  end
end

require Rails.root.join('lib', 'rails_admin', 'ops_dashboard.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::OpsDashboard)

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard do                    # mandatory
      statistics false
    end
    index                         # mandatory
    new
    show
    edit
    delete
    show_in_app
    ops_dashboard

    ## With an audit adapter, you can add:
    # history_index
    # history_show

    signup_link
  end

  config.main_app_name = Proc.new { |controller| [ "Dashboard :: #{Rails.env.try(:titleize)} :: #{LineOfBusiness.business["name"]}", controller.params[:action].try(:titleize) ] }


  config.authorize_with :cancan
  config.current_user_method &:current_user

  config.included_models = [
    'User', 'ClosedFeature', 'DiaryNote'
  ]

  config.model ClosedFeature do
    list do
      sort_by :user_id
      field :user_id do
        label "User ID"
      end
      field :dashboard_compound_key do
        label "Dashboard Compound Key"
      end
    end
  end

  config.model 'User' do
    list do
      field :id do
        label "ID"
      end
      field :name_last do
        label "Last Name"
      end
      field :name_first do
        label "First Name"
      end
      field :email
      field :dashboard_lan_id do
        label "Lan ID"
      end
      field :roles
      field :last_sign_in_at do
        label "Last Sign In"
      end
      field :sign_in_count do
        label "# Sign Ins"
      end
    end

    field :login
    field :dashboard_lan_id do
      label 'Dashboard LAN ID'
    end
    field :email
    field :password do
      help 'Required only if adding a new user or changing password'
    end
    field :password_confirmation do
      help 'Required only if adding a new user or changing password'
    end

    field :dashboard_adjuster_id do
      label 'Dashboard Adjuster ID'
      help 'Required if user is an Adjuster'
    end
    field :dashboard_manager_id do
      label 'Dashboard Manager ID'
      help do
        if bindings[:view]._current_user.roles.pluck(:name).include?('manager')
          ''
        else
          'Required. Length up to 255.'
        end
      end
      read_only do
        bindings[:view]._current_user.roles.pluck(:name).include?('manager')
      end
      default_value do
        if bindings[:view]._current_user.roles.pluck(:name).include?('manager')
          bindings[:view]._current_user.dashboard_manager_id
        else
          ''
        end
      end
    end
    field :name_first
    field :name_last
    field :finished_registration
    field :roles do
      inline_add false
    end
    field :dashboard_lan_domain
    field :authentication_token do
      read_only true
      help ''
    end
    field :remember_created_at do
      help ''
      read_only true
    end
    field :sign_in_count do
      help ''
      read_only true
    end
    field :current_sign_in_at do
      help ''
      read_only true
    end
    field :last_sign_in_at do
      help ''
      read_only true
    end
    field :current_sign_in_ip do
      help ''
      read_only true
    end
    field :last_sign_in_ip do
      help ''
      read_only true
    end
    field :reset_password_sent_at do
      help ''
      read_only true
    end
  end
end
