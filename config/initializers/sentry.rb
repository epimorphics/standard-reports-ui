# frozen-string-literal: true

Raven.configure do |config|
  config.dsn = config.dsn = 'https://96fe8408c7cf4b789a47bf3866897353@sentry.io/1859755'
  config.current_environment = ENV['DEPLOYMENT_ENVIRONMENT'] || Rails.env
  config.environments = %w[production test]
  config.release = Version::VERSION
  config.tags = { app: 'lr-dgu-std-reports' }
  config.excluded_exceptions += ['ActionController::BadRequest']
end
