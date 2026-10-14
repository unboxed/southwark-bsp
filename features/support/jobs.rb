ActiveJob::Base.queue_adapter = :delayed_job
Delayed::Worker.delay_jobs = false
