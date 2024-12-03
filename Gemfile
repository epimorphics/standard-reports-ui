# frozen_string_literal: true

source 'https://rubygems.org'

gem 'execjs'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'libv8-node'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# LR-common dependencies
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'modernizr-rails'
gem 'modulejs-rails'

# application dependencies
gem 'faraday'
gem 'faraday_middleware'
gem 'get_process_mem'
gem 'jquery-ui-rails'
gem 'js-routes'
gem 'leaflet-rails'
gem 'prometheus-client'
gem 'puma'
gem 'puma-metrics'
gem 'responders'
gem 'sentry-ruby'
gem 'yajl-ruby', require: 'yajl'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Use Unicorn as the app server
  gem 'unicorn'
end

group :test do
  gem 'capybara_minitest_spec'
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  gem 'minitest-spec-rails'
  gem 'minitest-vcr'
  gem 'mocha'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# TODO: In production you want to set this to the gem from the epimorphics package repo
source 'https://rubygems.pkg.github.com/epimorphics' do
  gem 'json_rails_logger', '~> 1.0.0'
  gem 'lr_common_styles'
end

# rubocop:disable Layout/LineLength
# TODO: While running the rails app locally for testing you can set gems to your local path
# ! These "local" paths do not work with a docker image - use the repo instead
# gem 'json_rails_logger', path: '~/Epimorphics/shared/json-rails-logger/'
# gem 'lr_common_styles', path: '~/Epimorphics/clients/land-registry/projects/lr_common_styles/'
# rubocop:enable Layout/LineLength
