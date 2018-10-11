# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'dashboard-tool'
set :repo_url, 'git@dashboard/dashboard-tool.git'
set :puma_threads, [4, 16]
set :puma_workers, 4
set :puma_bind,       "unix:///home/vagrant/dashboard-tool/puma.sock"
set :puma_state,      "/home/vagrant/dashboard-tool/shared/puma.state"
set :puma_pid,        "/home/vagrant/dashboard-tool/shared/puma.pid"
set :puma_access_log, "/home/vagrant/dashboard-tool/shared/log/puma.error.log"
set :puma_error_log,  "/home/vagrant/dashboard-tool/shared/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true 
set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
set :nginx_config_name, "dashboard"
set :nginx_socket_flags, "fail_timeout=0"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/vagrant/dashboard-tool'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# We're using rails in our tasks so this is necessary
set :resque_environment_task, true

# Set the resque workers (hash of queue: numworkers)
set :workers, '*' => 1

# Default value for :linked_files is []
# set :linked_files, %w{config/.env}

# Default value for linked_dirs is []
set :linked_dirs, %w{config/dotenv log}

# if the LD_LIBRARY_PATH and NLS_LANG aren't set, capistrano can't bundle the oracle adapter
# Default value for default_env is {}
set :default_env, {
  'LD_LIBRARY_PATH' => '/opt/oracle/instantclient_11_2',
  'NLS_LANG' => 'AMERICAN_AMERICA.AL32UTF8'
}

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, keys: ['~/.ssh/id_rsa'], forward_agent: true, user: 'vagrant', port: 22

# Upload Nginx config and enable
# cap staging puma:nginx_config 

# Upload Puma config
# cap staging puma:config 

namespace :deploy do

  desc 'Start puma'
  task :start do
    on roles (fetch(:puma_role)) do |role|
      puma_switch_user(role) do
        if test "[ -f #{fetch(:puma_conf)} ]"
          info "using conf file #{fetch(:puma_conf)}"
        else
          invoke 'puma:config'
        end
        within current_path do
          with rack_env: fetch(:puma_env), rails_env: fetch(:puma_env) do
            execute :puma, "-C #{fetch(:puma_conf)} --daemon"
          end
        end
      end
    end
  end

  desc 'restart puma'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after :publishing, :restart

  desc 'clear and warm the cache after deploy'
  task :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute "cd #{release_path} && bundle exec rake RAILS_ENV=#{fetch(:rails_env)} cache:warm"
      end
    end
  end

  desc 'Uploads local config/dotenv/* to remote shared/config/dotenv/*'
  task :upload_dotenv do
    on roles(:app) do
      config_path = File.join(shared_path, 'config', 'dotenv')
      execute "mkdir -p #{config_path}"
      dotenv_folder = File.join(Dir.pwd, 'config', 'dotenv')
      local_dotenv_files = Dir.entries(dotenv_folder) - ['.', '..']
      local_dotenv_files.each do |file_path|
        filename = file_path.split('/').last
        remote_path = File.join(config_path, filename)
        local_path = File.join(dotenv_folder, filename)
        upload!(local_path, remote_path)
      end
    end
  end
end

after 'deploy:restart', 'resque:restart'
after 'deploy:restart', 'resque:scheduler:restart'
