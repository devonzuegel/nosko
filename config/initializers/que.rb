Que.wake_interval = (ENV['QUE_INTERVAL'] || 10).to_i.seconds
Que.mode          = (ENV['QUE_MODE']     || :async).to_sym
Que.worker_count  = (ENV['QUE_WORKERS']  || 1).to_i