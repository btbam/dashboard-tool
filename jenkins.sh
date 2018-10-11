#!/bin/bash -l
eval $(ssh-agent)
ssh-add ~/.ssh/jenkins-ci.id_rsa
source ~/.bashrc

set -e

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LD_LIBRARY_PATH='/opt/oracle/instantclient_11_2'
export NLS_LANG='AMERICAN_AMERICA.AL32UTF8'
export RAILS_ENV='test'

cd "$WORKSPACE"

cat > config/database.yml <<EOF
test:
  adapter: postgresql
  database: dashboard_test
  username: postgres
EOF

cat > config/database_dashboard_writable.yml <<EOF
test:
  adapter: postgresql
  database: dashboard_test
  username: postgres
EOF

rvm use 2.1@dashboard
gem install bundler
bundle install
bundle exec rake db:drop db:create db:migrate db:seed

set +e

bundle exec rake lint:all
lint_status=$?

bundle exec rake karma:run
karma_status=$?

bundle exec rake rspec:run
rspec_status=$?

[ $lint_status -eq 0 -a $karma_status -eq 0 -a $rspec_status -eq 0 ]
