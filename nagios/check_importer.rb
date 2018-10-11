#!/usr/bin/env ruby

require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'net/https'
require 'optparse'
require 'pathname'
require 'uri'

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3
STATUS = ['OK', 'WARNING', 'CRITICAL', 'UNKNOWN']

def alert_msg(status, msg)
  "#{STATUS[status]} - #{msg}"
end

status = UNKNOWN
last_success = 'never'
insecure = false

op = OptionParser.new do |opts|
  opts.banner = 'Usage: check_importer.rb [options] URL key'

  opts.separator ''
  opts.separator 'Specific options:'

  opts.on('-k', '--insecure', 'Allow insecure SSL connections.') do
    insecure = true
  end

  opts.on('-h', '--help', 'Display this help list.') do
    puts opts.help
    exit UNKNOWN
  end
end
op.parse!

uri = URI.parse(ARGV.shift) rescue nil
unless uri
  STDERR.puts 'URL is required.'
  exit UNKNOWN
end

key = ARGV.shift.to_s
if key.empty?
  STDERR.puts 'Key is required.'
  exit UNKNOWN
end

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme = 'https'
http.verify_mode = OpenSSL::SSL::VERIFY_NONE if insecure
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth(uri.user, uri.password) unless uri.user.empty?

response = http.request(request)
if response.code == '200'
  data = JSON.parse(response.body) rescue nil
  if data
    alerts = data['nagios_alerts']
    alert = alerts.detect { |alert| !alert[key].nil? }

    begin
      alert = alert[key]
      value = alert['last_success']
      last_success = Time.parse(value).utc
      today = Time.now.utc
      diff = today.to_i - last_success.to_i

      value = alert['status']
      status = value.constantize rescue UNKNOWN

      msg = "Last success: #{last_success}"
    rescue
      if alert
        msg = 'Invalid/missing value for last_success'
      else
        msg = "Key not found: #{key}"
      end
    end
  else
    msg = 'Unsupported API response format (must be JSON)'
  end
else
  msg = "API response: #{response.code} #{response.message}"
end

puts alert_msg(status, msg)
exit status
