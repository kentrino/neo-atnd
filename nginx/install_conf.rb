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
  opt.on('-y', 'Yes to all') { all_yes = true }
  opt.parse!(ARGV)
end

# Install .conf files =====================================================
nginx_source_dir = DIR

check_env %w(OS_NGINX_CONF_DIR)
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

  File.write(conf[:dest], File.read(conf[:source])) if all_yes || yes
end

# Make cache and log directory ============================================
FileUtils.mkdir_p('/var/cache/nginx/')
FileUtils.mkdir_p('/var/log/nginx')
