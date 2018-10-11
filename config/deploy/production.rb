# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{127.0.0.1 127.0.0.1}
role :web, %w{127.0.0.1 127.0.0.1}
role :db,  %w{127.0.0.1}
role :resque_worker, %w{127.0.0.1 127.0.0.1}
role :resque_scheduler, %w{127.0.0.1 127.0.0.1}

set :resque_log_file, "log/resque.log"

set :rails_env, 'production'
set :branch, 'v2.19.2'

set :default_environment, 'RAILS_ENV' => 'production'

set :application, 'dashboard-tool'
set :puma_env, 'production'
set :nginx_port, 80
set :nginx_use_ssl, true

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
 set :ssh_options, {
   keys: ['~/.ssh/id_rsa'],
   forward_agent: true,
   user: 'vagrant',
   port: 22
 }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
