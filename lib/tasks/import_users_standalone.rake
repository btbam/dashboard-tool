$stdout.sync = true

namespace :import do
  desc 'import/update users using a csv'
  task :users_standalone, [:filename] => [:environment] do |_t, args|
    rows = ::CSV.open(args.filename, 'r:ISO-8859-15:UTF-8')

    rows.shift # skip_headers
    user_auths = []

    rows.each do |row|
      name_first = row[1].split(',')[1]
      name_last = row[1].split(',')[0]
      email = row[3]
      if row[9].downcase == 'adjuster'
        dashboard_adjuster_id = row[5]
        dashboard_manager_id = row[8]
      elsif row[9].downcase == 'manager'
        dashboard_adjuster_id = nil
        dashboard_manager_id = row[5]
      else
        dashboard_adjuster_id = nil
        dashboard_manager_id = nil
      end
      dashboard_lan_id = row[2].split('/')[1]
      dashboard_lan_domain = row[2].split('/')[0]
      roles = [Role.find_by(name: row[9].downcase)]
      unless email.empty?
        u = User.find_or_initialize_by(email: email.downcase.strip)
        u.name_first = name_first.titleize.strip
        u.name_last = name_last.titleize.strip
        u.login = dashboard_lan_id.downcase.strip
        u.dashboard_lan_id = dashboard_lan_id.downcase.strip
        u.dashboard_lan_domain = dashboard_lan_domain.downcase.strip
        u.dashboard_manager_id = dashboard_manager_id ? dashboard_manager_id.strip : dashboard_manager_id
        u.dashboard_adjuster_id = dashboard_adjuster_id ? dashboard_adjuster_id.strip : dashboard_adjuster_id
        u.email = email.downcase.strip
        u.password = User.generate_random_password,
                     u.password_confirmation = u.password
        # (re)set the user's roles
        u.role_permissions.delete_all
        u.roles = roles
        u.save
        if u.errors.present?
          puts u.errors.messages.inspect
        else
          print '.'
        end
        user_auths << u
      end
    end

    puts "\n"
    user_auths.each do |u|
      puts u.email
    end
  end
end
