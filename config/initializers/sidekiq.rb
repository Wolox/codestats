# Sidekiq configuration file

require 'sidekiq'

url = ''
if ENV['REDISCLOUD_URL']
  url = ENV['REDISCLOUD_URL']
elsif ENV['REDISTOGO_URL']
  url = ENV['REDISTOGO_URL']
else
  url = "redis://#{ENV.fetch('REDIS_1_PORT_6379_TCP_ADDR', '127.0.0.1')}:6379"
end

Sidekiq.configure_server do |config|
  config.redis = { size: 2, url: url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: url }
end

Sidekiq.default_worker_options = { 'backtrace' => true }
