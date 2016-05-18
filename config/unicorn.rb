# Restrict rake:unicorn command within RAILS_ROOT
rails_root = File.expand_path('../../', __FILE__)
working_directory rails_root

worker_processes 1
timeout 15

# Suppress down time when reload
preload_app true

listen File.expand_path('../../tmp/unicorn.sock', __FILE__)
pid File.expand_path('../../tmp/unicorn.pid', __FILE__)

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Logs
stderr_path File.expand_path('../../log/unicorn.error.log', __FILE__)
stdout_path File.expand_path('../../log/unicorn.access.log', __FILE__)

# Avoid bundle error Bundler::GemfileNotFound
ENV['BUNDLE_GEMFILE'] = rails_root + '/Gemfile'
