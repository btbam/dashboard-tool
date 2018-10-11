class UserCsv
  attr_reader :filename, :user, :row, :logger

  def initialize(filename:)
    @filename = filename
    @user = User.new
    @logger = Logger.new(STDOUT)
  end

  def import
    rows = ::CSV.open(filename, 'r:ISO-8859-15:UTF-8')
    rows.shift # skip_headers
    import_rails_users_from_csv(rows)
  end

  private

  def import_rails_users_from_csv(rows)
    rows.map do |row|
      @user.email = row[3].downcase.strip
      email = user.email
      next if email.empty?
      @user = User.find_or_initialize_by(email: email)
      @row = row
      import_rails_user_from_row
    end
  end

  def import_rails_user_from_row
    set_user_attributes
    make_or_update_user
  end

  def set_user_attributes
    set_user_name
    set_dashboard_domain_lan
    set_dashboard_adjuster_manager
    user.role_permissions.delete_all
    @user.roles = [Role.find_by(name: row[9].downcase)]
    @user.password = User.generate_random_password
  end

  def set_user_name
    @user.name_last, @user.name_first = field_split(row[1], ',')
  end

  def set_dashboard_domain_lan
    @user.dashboard_lan_domain, @user.dashboard_lan_id = field_split(row[2], '/')
  end

  def set_dashboard_adjuster_manager
    dashboard_id_from_role_name(row[9], row[5], row[8])
  end

  def field_split(value, split_string)
    value.split(split_string)
  end

  def dashboard_id_from_role_name(role_name, adjuster_id, manager_id)
    downcased_role_name = role_name.downcase
    if downcased_role_name == 'adjuster'
      @user.dashboard_adjuster_id = adjuster_id
      @user.dashboard_manager_id = manager_id
    elsif downcased_role_name == 'manager'
      @user.dashboard_adjuster_id = nil
      @user.dashboard_manager_id = adjuster_id
    else
      @user.dashboard_adjuster_id = nil
      @user.dashboard_manager_id = nil
    end
  end

  def make_or_update_user
    santize_attributes
    handle_duplicate_attributes
    user.save
    log_errors

    [user.email, user.password]
  end

  def handle_duplicate_attributes
    @user.login = user.dashboard_lan_id
    @user.password_confirmation = user.password
  end

  def santize_attributes
    user.attributes.each do |key, value|
      @user[key] = if %w(name_first name_last).include?(key)
                     value.titleize.strip
                   elsif %w(dashboard_lan_id dashboard_lan_domain email).include?(key)
                     value.downcase.strip
                   elsif %w(dashboard_manager_id dashboard_adjuster_id).include?(key)
                     user[key].try(:strip)
                   else
                     value
                   end
    end
  end

  def log_errors
    errors = user.errors
    if errors.present?
      logger.info errors.messages.inspect
    else
      logger.info 'created/updated: ' + user.email
    end
  end
end
