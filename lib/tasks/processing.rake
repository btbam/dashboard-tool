require 'rubygems'
require 'pp'
require 'json'
require 'benchmark'

$stdout.sync = true

namespace :processing do
  desc 'threaded eCSO/Claim Note Processor'
  task :notes, [:useDB] => [:environment] do |_t, _args|
    Rails.application.eager_load!
    processor = ETL::NoteProcessor.new
    processor.run
  end

  desc 'scrub personally identifiable information from notes'
  task :scrub_notes, [:useDB] => [:environment] do |_t, _args|
    processor = ETL::DatabaseScrubber.new(model: Note, columns: [:message, :original_message])
    processor.run
  end
end
