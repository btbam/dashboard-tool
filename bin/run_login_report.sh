#!/bin/bash
#
# usage: see below
#
# Runs the login report on the Dashboard server, copies the files down to the
# current directory, and removes the files from the server.
#
# See the help for default values.

DEFAULT_SERVER=dashboard-claim.dashboard.net
user=vagrant
environment=production
app_home=/home/vagrant/dashboard-tool
rails_root=$app_home/current
csv_file_path=$app_home/rails_users.csv
remote_output_dir=$rails_root

usage() {
    cat <<EOF >&2
usage: run_login_report.sh [-u user] [-e env] [-r rails_root] [-h | -?]
                           [-c csv-file-path] [-o remote-output-dir]
                           [server]

Runs the login report and copies the files to the local current directory.
Deletes the files from the server when done.

-u user    SSH user ($user)
-e env     Rails environment ($environment)
-r dir     Rails root dir ($rails_root)
-c ru_csv  CSV file containing rails user definitions, read for role strings
           ($csv_file_path)
-o dir     Output directory on remote server ($remote_output_dir)
-h / -?    This help

Server default is $DEFAULT_SERVER.

EOF
}

while getopts "u:e:r:w:o:h?" opt ; do
    case $opt in
        u) user=$OPTARG ;;
        e) environment=$OPTARG ;;
        r) rails_root=$OPTARG ;;
        c) csv_file_path=$OPTARG ;;
        o) remote_output_dir=$OPTARG ;;
        [h\?]) usage ; exit 0 ;;
        *) usage ; exit 1 ;;
    esac
done
shift $(($OPTIND-1))
server=${1:-$DEFAULT_SERVER}

ssh -l $user $server <<EOF
cd $rails_root
RAILS_ENV=$environment bundle exec rake report:logins[$csv_file_path,$remote_output_dir]
EOF

scp -C $user@$server:$remote_output_dir/dashboard_logins*.csv .
ssh -l $user $server rm $remote_output_dir/dashboard_logins*.csv
