if Rails.env.development? || Rails.env.test?
  namespace :rspec do
    desc 'Run all rspecs'
    RSpec::Core::RakeTask.new(:run) do |task|
      puts "\n"
      puts "Running Rspec..."
      task.pattern = Dir.glob('spec/**/*_spec.rb')
      task.rspec_opts = '--color --tag ~skip'
    end
  end
end
