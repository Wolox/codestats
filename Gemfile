source 'http://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'

gem 'google-webfonts-rails'

# Use postgresql as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma'

# Use fontawesome for common icons
gem 'font-awesome-rails'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use autoprefixer to avoid writing css prefixes
gem 'autoprefixer-rails'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

gem 'therubyracer'

gem 'bootstrap-sass'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'loadjs'

gem 'carrierwave'

gem 'turbolinks'

gem 'jquery-turbolinks'

# User Authentication
gem 'devise'
gem 'devise-async'
gem 'devise_invitable'

gem 'responders', '2.0'

gem 'active_model_serializers'

gem 'foreman'

# Enables Slim templates
gem 'slim-rails'

# Sidekiq
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'sidekiq-failures'
gem 'sidekiq_mailer'

# Authorization Policies
gem 'pundit'

# Exceptions Report
gem 'rollbar'

gem 'meta-tags'

# SEO Meta Tags
gem 'metamagic'

# Github OAuth
gem 'omniauth-github'

gem 'octokit', '~> 4.0'

gem 'faraday-http-cache'

# API
gem 'versionist'

gem 's3_uploader'

gem 'httparty'

# JS Chart
gem 'chart-js-rails'

# Friendly URLS
gem 'friendly_id', '~> 5.1.0'

gem 'newrelic_rpm'

# Decorator
gem 'draper'

# Selectize.js
gem 'selectize-rails'

# Async Requests
gem 'async_request'

group :development do

  # Gem to detect N+1 queries
  gem 'bullet'

  gem 'better_errors'
  gem 'web-console'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'binding_of_caller'

  # Capistrano
  # Remove comments if using Capistrano
  # gem 'capistrano', '3.2.1'
  # gem 'capistrano-maintenance', github: 'capistrano/maintenance', require: false
  # gem 'capistrano-rails'
  # gem 'capistrano-rbenv', '~> 2.0'
  # gem 'capistrano-rbenv-install', '~> 1.2.0'
  # gem 'capistrano-nginx-unicorn'
  # gem 'capistrano-sidekiq'
  # gem 'capistrano-rails-console'
  # gem 'capistrano-db-tasks', require: false
  # gem 'capistrano-faster-assets', '~> 1.0'
  # gem 'capistrano-postgresql', '~> 4.2.0'
  # gem 'airbrussh', require: false
end

group :development, :test do
  gem 'awesome_print'

  gem 'byebug'
  gem 'pry-rails'

  gem 'factory_girl_rails'
  gem 'faker'

  # Lints
  gem 'rubocop'
  gem 'scss-lint'

  # Load environment variables from file
  gem 'dotenv-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'rspec-sidekiq'

  gem 'capybara'
  gem 'formulaic'
  gem 'launchy'

  gem 'timecop'
  gem 'webmock'

  # CodeClimate Reporter
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0'

  # CodeStats
  gem 'rubycritic', require: nil
  gem 'codestats-metrics-reporter', '0.1.5', require: nil
end

group :production do
  gem 'rails_12factor'
  gem 'recipient_interceptor'
end
