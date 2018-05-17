source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# LR-common dependencies
gem 'jquery-rails'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'modernizr-rails'
gem 'modulejs-rails'
gem 'lr_common_styles', github: "epimorphics/lr_common_styles"

# application dependencies
gem 'jquery-ui-rails'
gem 'leaflet-rails'
gem 'js-routes'
gem 'faraday'
gem 'faraday_middleware'
gem 'yajl-ruby', require: 'yajl'
gem 'responders', '~> 2.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Use Unicorn as the app server
  gem 'unicorn'

end

group :test do
  gem 'minitest-spec-rails'
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  gem 'capybara_minitest_spec'
  gem 'mocha'
  gem 'minitest-vcr'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
