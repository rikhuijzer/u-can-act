# Don't delay jobs when running this as a service of the base platform locally in development
Delayed::Worker.delay_jobs = false if ENV['RUNNING_AS_SERVICE'].present?

if Rails.env.production?
  if ENV['PAPERTRAIL_HOST'].present?
    Delayed::Worker.logger = RemoteSyslogLogger.new(ENV['PAPERTRAIL_HOST'],
                                           ENV['PAPERTRAIL_PORT'].to_i,
                                           program: "rails-#{ENV['PAPERTRAIL_PROGRAM']}")
  end
else
  Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'dj.log'))
end
