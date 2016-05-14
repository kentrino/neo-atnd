#!ruby
require 'fileutils'
require 'erb'

def check_env(ary)
  ary.each{ |env|
    unless ENV[env]
      p "Please specify #{env} first."
      exit
    end
  }
end

def from_erb(erb_file, docker)
  conf_erb_tempalte = File.read(erb_file, :encoding => Encoding::UTF_8)
  erb = ERB.new(conf_erb_tempalte)
  conf = erb.result(binding)
  conf.split("\n")
    .reject{|l| l =~ /^\s*#/ }
    .reject{|l| l =~ /^\s*$/}
    .push('')
    .join("\n")
end

DIR = File.expand_path(File.dirname(__FILE__)).to_s
RAILS_ROOT = File.expand_path('../../../', __FILE__)

# Create .conf files ======================================================
check_env %w(APP_NAME SERVER_NAME OS)
nginx_source_dir = DIR

[true, false].each do |docker|
  prefix = ''
  if docker
    prefix = 'docker.'
  end

  app_conf = {
    source: nginx_source_dir + '/vh.conf.erb',
    dest: nginx_source_dir+ '/' + prefix + 'vh.conf'
  }

  main_conf = {
    source: nginx_source_dir + '/nginx.conf.erb',
    dest: nginx_source_dir + '/' + prefix + 'nginx.conf'
  }

  [main_conf, app_conf].each do |conf|
    File.write(conf[:dest], from_erb(conf[:source], docker))
  end
end
