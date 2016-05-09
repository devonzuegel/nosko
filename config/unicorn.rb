worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection

  Que.wake_interval = (ENV['que_wake_interval'] || 10).to_i.seconds
  Que.mode          = (ENV['que_mode']          || :async).to_sym
  Que.worker_count  = (ENV['que_workers']       || 1).to_i
end
