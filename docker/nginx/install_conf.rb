#!ruby
require 'fileutils'
require 'highline'
require 'optparse'

def check_env(ary)
  ary.each do |env|
    unless ENV[env]
      p "Please specify #{env} first."
      exit
    end
  end
end

DIR = File.expand_path(File.dirname(__FILE__)).to_s
RAILS_ROOT = File.expand_path('../../../', __FILE__)

# Parse options ===========================================================
all_yes = false
OptionParser.new do |opt|
  opt.on('-y', 'Yes to all'){|v| all_yes = true}
  opt.parse!(ARGV)
end

# Install .conf files =====================================================
check_env %w(APP_NAME OS_NGINX_CONF_DIR)
nginx_source_dir = DIR
nginx_dest_dir = ENV['OS_NGINX_CONF_DIR']

app_conf = {
  source: nginx_source_dir + '/vh.conf',
  dest: nginx_dest_dir + '/servers/' + ENV['APP_NAME'] + '.conf'
}

main_conf = {
  source: nginx_source_dir + '/nginx.conf',
  dest: nginx_dest_dir + '/nginx.conf'
}

cli = HighLine.new
[main_conf, app_conf].each do |conf|
  unless all_yes
    yes = cli.ask("Generate #{conf[:dest]} from #{conf[:source]}? (Y/n)") == 'y'
  end

  if all_yes|| yes
    File.write(conf[:dest], File.read(conf[:source]))
  end
end

# Make cache and log directory ============================================
FileUtils.mkdir_p('/var/cache/nginx/')
FileUtils.mkdir_p('/var/log/nginx')
