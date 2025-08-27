# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Use Puma as the app server
gem 'puma'

# Assets group is temporarily disabled due to versioning issues with Rails
# group :assets do
# Use SCSS for stylesheets
gem 'sass-rails'
# ! Webpacker removes the need for Uglifier so we can safely remove it.
# ! If you want to use Uglifier, uncomment the line below
# ! and ensure you have the 'uglifier' gem in your Gemfile.
# ! See https://www.mintbit.com/blog/rails-5-6-upgrade-es6-uglifier-bug/
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', require: false
# end

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'

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
gem 'faraday-encoding', '~> 0.0.6'
gem 'faraday-follow_redirects', '~> 0.3.0'
gem 'faraday-retry', '~> 2.0'

gem 'get_process_mem'
gem 'jquery-ui-rails'
gem 'js-routes'
gem 'leaflet-rails'
gem 'prometheus-client'
gem 'puma-metrics'
gem 'responders'
gem 'sentry-rails'
gem 'yajl-ruby', require: 'yajl'

gem 'byebug', groups: %i[development test]
gem 'dotenv', groups: %i[development test]

group :development do
  gem 'ruby-lsp'
  gem 'solargraph'
  # Original meta_request gem is broken. Using fork provided by rails_panel
  # (https://github.com/dejan/rails_panel/issues/209#issuecomment-2621877079_)
  gem 'meta_request', github: 'dejan/rails_panel', ref: 'meta_request-v0.8.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development, :test do
  gem 'foreman'
  gem 'ostruct'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :test do
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  gem 'minitest-spec-rails'
  gem 'minitest-vcr'
  gem 'mocha'
  gem 'vcr'
  gem 'webmock'
end


# TODO: In production you want to set this to the gem from the epimorphics group package repository
source 'https://rubygems.pkg.github.com/epimorphics' do
  gem 'json_rails_logger'
  gem 'lr_common_styles'
end

# TODO: For gem development and testing, you can use the local path to the gem
# ! These "local" paths do not work with a docker image - use the remote gem instead
# gem 'json_rails_logger', path: '~/Epimorphics/shared/json-rails-logger/'
# gem 'lr_common_styles', path: '~/Epimorphics/clients/land-registry/projects/lr_common_styles/'
