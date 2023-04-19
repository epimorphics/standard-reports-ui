# frozen_string_literal: true

source 'https://rubygems.org'

gem 'execjs', '< 2.8.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '< 6.0.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'libv8-node', '>= 16.10.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.1.0', group: :doc

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
gem 'get_process_mem', '~> 0.2.7'
gem 'jquery-ui-rails'
gem 'js-routes', '< 2.0'
gem 'leaflet-rails'
gem 'prometheus-client', '~> 4.0'
gem 'puma'
gem 'responders', '~> 2.0'
gem 'sentry-ruby', '~> 5.2'
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

# rubocop:disable Layout/LineLength
# TODO: While running the rails app locally for testing you can set gems to your local path
# ! These "local" paths do not work with a docker image - use the repo instead
# gem 'json_rails_logger', '~> 0.3.5', path: '~/Epimorphics/shared/json-rails-logger/'
# gem 'lr_common_styles', '~> 1.9.1', path: '~/Epimorphics/clients/land-registry/projects/lr_common_styles/'
# rubocop:enable Layout/LineLength

# TODO: In production you want to set this to the gem from the epimorphics package repo
source 'https://rubygems.pkg.github.com/epimorphics' do
  gem 'json_rails_logger', '~> 0.3.5'
  gem 'lr_common_styles', '~> 1.9.1'
end
