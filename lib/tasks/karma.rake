namespace :karma  do
  task start: :environment do
    puts "\n"
    with_tmp_config :start
  end

  task run: :environment do
    puts "\n"
    puts 'Running Karma...'
    with_tmp_config :start, '--single-run'
  end

  private

  def with_tmp_config(command, args = nil)
    Tempfile.open('karma_unit.js', Rails.root) do |f|
      f.write unit_js(application_spec_files)
      f.flush
      unless system "karma #{command} #{f.path} #{args}"
        exit 1
      end
    end
  end

  def application_spec_files
    sprockets = Rails.application.assets
    sprockets.find_asset('application_spec.js').to_a.map { |asset| asset.pathname.to_s }
  end

  def unit_js(files)
    unit_js = File.open('spec/karma/karma.conf.js', 'r').read
    unit_js.gsub 'APPLICATION_SPEC', "\"#{files.join("\",\n\"")}\""
  end
end
