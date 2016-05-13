#!ruby
require 'fileutils'
require 'highline'
require 'erb'
require 'optparse'

def check_env(ary)
  ary.each{ |env|
    unless ENV[env]
      p "Please specify #{env} first."
      exit
    end
  }
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
check_env %w(APP_NAME  SERVER_NAME OS_NGINX_CONF_DIR OS)
nginx_source_dir = DIR
nginx_dest_dir = ENV['OS_NGINX_CONF_DIR']

servers_dir = nginx_dest_dir + '/servers'
unless File::ftype(servers_dir) == 'directory'
  Dir.mkdir(servers_dir, 0755)
end

app_conf = {
  source: nginx_source_dir + '/app.conf.erb',
  dest: servers_dir + '/' + ENV['APP_NAME'] + '.conf'
}

main_conf = {
  source: nginx_source_dir + '/nginx.conf.erb',
  dest: nginx_dest_dir + '/nginx.conf'
}


def from_erb(erb_file)
  conf_erb_tempalte = File.read(erb_file, :encoding => Encoding::UTF_8)
  erb = ERB.new(conf_erb_tempalte)
  erb.result(binding)
end

cli = HighLine.new
[main_conf, app_conf].each{ |conf|
  unless all_yes
    yes = cli.ask("Generate #{conf[:dest]} from #{conf[:source]}? (Y/n)") == 'Y'
  end

  if all_yes|| yes
    File.write(conf[:dest], from_erb(conf[:source]))
  end
}

# Make cache and log directory ============================================
FileUtils.mkdir_p('/var/cache/nginx/')
FileUtils.mkdir_p('/var/log/nginx')

