$stdout.sync = true

namespace :import do
  desc 'import/update users using a csv'
  task :users, [:filename] => [:environment] do |_t, args|
    UserCsv.new(filename: args[:filename] || 'rails_users.csv').import
  end
end
