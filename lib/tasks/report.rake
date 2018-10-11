require 'rubygems'

# Rake tasks that run reports
namespace :report do
  # To specify CSV user file and output_dir, call the logins task like this:
  #
  #     rake report:logins[~/dashboard-tool/rails-users.csv,/tmp]
  #     rake report:logins[~/dashboard-tool/rails-users.csv]
  #
  # You can specify CSV file or CSF file and output dir. There is no way to
  # specify just the output dir.

  desc 'generate a report about logins; outputs two CSV files'
  task :logins, :rails_users_csv, :output_dir do |_t, args|
    Rake.application.invoke_task(:environment)
    LoginReport.new.run_report(args)
  end
end
