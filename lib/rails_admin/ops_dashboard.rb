module RailsAdmin
  module Config
    module Actions
      class OpsDashboard < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :breadcrumb_parent do
          nil
        end

        register_instance_option :http_methods do
          [:get, :put]
        end

        register_instance_option :controller do
          proc do
            if request.put? # Running command
              @previous_command = case params[:command]
              when 'puma_status'
                'ps -ef | grep puma'
              when 'puma_restart'
                "kill -0 $( cat #{Rails.root.to_s}/shared/puma.pid )"
                "cd #{Rails.root.to_s} && bundle exec pumactl -S #{Rails.root.to_s}/shared/puma.state restart"
              when 'puma_log'
                "tail -n#{params[:lines]} #{Rails.root.to_s}/log/puma_error.log"
              when 'nginx_stop'
                '/usr/sbin/nginx stop'
              when 'nginx_start'
                '/usr/sbin/nginx start'
              when 'nginx_status'
                '/usr/sbin/nginx status && ps -ef | grep nginx'
              when 'nginx_log'
                "tail -n#{params[:lines]} /var/log/nginx.log"
              when 'cache_warm'
                "cd #{Rails.root.to_s} && RAILS_ENV=#{Rails.env} bundle exec rake cache:warm >> log/cache_warm.log 2>&1 &"
              when 'cache_warm_log'
                "tail -n#{params[:lines]} #{Rails.root.to_s}/log/cache_warm.log"
              when 'rails_directory'
                "cd #{Rails.root.to_s} && ls -la"
              when 'log_directory'
                "cd #{Rails.root.to_s}/log && ls -la"
              when 'production_log'
                "tail -n#{params[:lines]} #{Rails.root.to_s}/log/production.log"
              when 'staging_log'
                "tail -n#{params[:lines]} #{Rails.root.to_s}/log/staging.log"
              when 'development_log'
                "tail -n#{params[:lines]} #{Rails.root.to_s}/log/development.log"
              else
                ''
              end
              @results = `#{@previous_command}`
              render action: :ops_dashboard
            elsif request.get?
              render @action.template_name
            else
              render rails_admin.ops_dashboard_path
            end
          end
        end

        register_instance_option :route_fragment do
          'ops_dashboard'
        end

        register_instance_option :unicorn_status do
          `ps -ef | grep unicorn`
        end

        register_instance_option :link_icon do
          'icon-home'
        end

        register_instance_option :statistics? do
          true
        end
      end
    end
  end
end
