import 'csv'

class ReportUser
  attr_accessor :user, :dashboard_role, :week_counts

  def initialize(user, dashboard_role = '')
    @user, @dashboard_role = user, dashboard_role
    @week_counts = []
  end

  def to_s
    "ReportUser[login=#{user.login}, role=#{dashboard_role}, week_counts=#{week_counts}]"
  end
end

# Generates a report about user logins. Creates two CSV files. One contains
# a detailed list of each login time for each user. The other groups logins
# into weekly counts and lists, for each user, the number of logins for the
# past N weeks.
#
# A week is defined as Sunday - Saturday.
class LoginReport
  DEFAULT_START_DATE = Time.new(2014, 6, 15).beginning_of_week(:sunday)
  DEFAULT_OUTPUT_DIR = '.'
  OUTPUT = 'dashboard_logins.csv'
  OUTPUT_RAW = 'dashboard_logins_detail.csv'

  attr_reader :files_generated

  def initialize
    @files_generated = []
  end

  # Runs the report and outputs two CSV files. @files_generated is set to
  # the paths of those two files.
  #
  # Options:
  #
  # * output_dir - where to put the output CSV files (optional; default is
  #   DEFAULT_OUTPUT_DIR
  #
  # * since - Text date (YYYY-MM-DD), report starts in the week containing
  #   that date (optional; default is DEFAULT_START_DATE)
  #
  # * rails_users_csv - contains Rails users; used to obtain Dashboard Role
  #   (optional)
  def run_report(options = {})
    output_dir = options[:output_dir] || DEFAULT_OUTPUT_DIR
    @files_generated = []
    report_users = load_report_users(options[:rails_users_csv])

    @since = since_date(options[:since])
    @this_week_start = Time.now.beginning_of_week(:sunday)
    @weeks_ago = generate_weeks_ago

    # TODO if there are ever more than two reports, extract out a report
    # class that handles common behavior.

    # Aggregated weekly login counts report
    with_output_to_csv(File.join(output_dir, OUTPUT)) do |csv|
      csv << week_headers
      report_users.each do |ru|
        count_logins(ru)
        # Week counts are reversed from the order in which we want to
        # display them, so reverse what we've stored.
        u = ru.user
        csv << [u.login, u.name_last, u.name_first, ru.dashboard_role,
                *ru.week_counts, ru.week_counts.sum]
      end
      csv << []
      week_totals = user_week_totals(report_users)
      csv << ['TOTAL', nil, nil, nil, *week_totals, week_totals.sum]
    end

    # Login detail report
    with_output_to_csv(File.join(output_dir, OUTPUT_RAW)) do |csv|
      csv << ['User', 'Login Time']
      report_users.each do |ru|
        u = ru.user
        u.sign_in_timestamps.each do |tstamp|
          t = Time.at(tstamp)
          csv << [u.login, t] if t >= @since
        end
      end
    end
  end

  def since_date(date_text)
    if date_text.blank?
      DEFAULT_START_DATE
    else
      Date.parse(date_text)
    end
  end

  # Returns an array containing week start dates, from the first day of the
  # report (@since) to the present week.
  def generate_weeks_ago
    d = @since
    weeks_ago = [].tap do |wa|
      while d <= @this_week_start
        wa << d
        d += 1.week
      end
    end
    weeks_ago
  end

  # Read users from database, match them with Dashboard Role in the CSV file, and
  # return ReportUser objects.
  def load_report_users(csv_file)
    users = User
            .select(:id, :login, :name_last, :name_first, :sign_in_timestamps)
            .order(:login)

    # Get role for each user by reading CSV file, if we have been given one
    # to read.
    user_roles = {}
    if csv_file
      CSV.foreach(csv_file, headers: true) do |row|
        role = row['Dashboard Role']
        role.sub!(/ - .*/, '') if role # remove explanatory text
        user_roles[row['LAN ID']] = role
      end
    end

    users.collect { |u| ReportUser.new(u, user_roles[u.login]) }
  end

  # Open CSV file for writing, call block, close CSV and add path to
  # @files_generated.
  def with_output_to_csv(path, &_block)
    CSV.open(path, 'w') do |csv|
      yield csv
    end
    @files_generated << path
  end

  # Headers for aggregated report.
  def week_headers
    headers = ['Login', 'Last Name', 'First Name', 'Role']
    headers += @weeks_ago.collect do |week_start|
      week_end = week_start + 1.week - 1.day
      "#{week_start.strftime('%b %d')} - #{week_end.strftime('%b %d')}"
    end
    headers << 'Total'
  end

  # Calculate and return totals for each week.
  def user_week_totals(report_users)
    report_users.inject(Array.new(@weeks_ago.length, 0)) do |totals, ru|
      ru.week_counts.each_with_index do |count, index|
        totals[index] += count
      end
      totals
    end
  end

  # Updates report user's week_counts with the weekly login counts for the
  # given user.
  def count_logins(report_user)
    weeks_ago_length = @weeks_ago.length
    report_user.week_counts = Array.new(weeks_ago_length, 0)
    report_user.user.sign_in_timestamps.each do |tstamp|
      t = Time.at(tstamp)
      next if t < @since

      # Keep looking back a week at a time until we find the week in which
      # the login time belongs.
      (weeks_ago_length - 1).downto(0) do |i|
        week_counts = report_user.week_counts[i]
        if t >= @weeks_ago[i]
          week_counts ||= 0
          week_counts += 1
          break
        end
      end
    end
  end
end
