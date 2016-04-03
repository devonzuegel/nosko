Que.wake_interval = 1.seconds
Que.mode          = (ENV['QUE_MODE'] || :async).to_sym
Que.worker_count  = (ENV['QUE_WORKERS'] || 4)