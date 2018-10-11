#!/usr/bin/env rake

if Rails.env.test? || Rails.env.development?
  require 'jshint'
  require 'rubocop/rake_task'
  require 'reek/rake/task'

  namespace :lint do
    # run all linters
    desc 'Run all linters'
    task all: [:jshint, :rubocop, :reek]

    # RuboCop
    desc 'Run RuboCop'
    puts "\n"
    RuboCop::RakeTask.new(:rubocop) do |task|
      task.options = ['--config', "#{File.join(Rails.root, 'config', 'rubocop.yml')}"]
      task.fail_on_error = false
    end

    # Reek
    Reek::Rake::Task.new do |task|
      task.config_file = File.join(Rails.root, 'config', 'reek.yml')
      task.source_files = '{app,lib,config}/{api,cotrollers,helpers,models,serializers,services,validators,tasks,initializers,lines_of_business}/**/{*.rb,*.rake}'
      task.fail_on_error = false
      # task.verbose = true
    end
    task :reek_msg do
      puts "\n"
      puts 'Running Reek...'
    end
    desc 'Run reek'
    task reek: :reek_msg

    # rails_best_practices
    desc 'Run rails_best_practices'
    task :rbp do
      puts 'Running Rails Best Practices...'

      options = {
        'exclude' => [
          /frontend/,
          /cookbooks/
        ]
      }
      analyzer = RailsBestPractices::Analyzer.new(Rails.root, options)
      analyzer.analyze
      analyzer.output
      fail if analyzer.runner.errors.size > 0
    end
    task rails_best_practices: :rbp

    # jshint
    desc 'Run jshint'
    task :jshint do
      puts 'Running jshint...'
      Rake::Task['jshint'].invoke
      puts "\n"
    end
  end
end
