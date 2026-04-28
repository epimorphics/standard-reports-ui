# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

require 'simplecov'
SimpleCov.start do
  # Exclude test and config directories from coverage analysis
  add_filter '/test/'
  add_filter '/config/'
end

# Fix compatibility with gems that expect the old MiniTest constant
# This needs to be set before requiring any minitest gems
MiniTest = Minitest unless defined?(MiniTest)

require 'minitest/rails'
require 'capybara/minitest'
require 'capybara/rails'
require 'mocha/minitest'

require 'minitest/reporters'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

# Extend Minitest::Expectation with Capybara matchers for _(page).must_have_css syntax
# This replaces functionality from the deprecated minitest-rails-capybara gem
module Minitest
  class Expectation
    # Delegate Capybara matchers to the target (page object)
    def must_have_css(selector, **)
      ctx.assert target.has_css?(selector, **),
                 "Expected page to have CSS '#{selector}'"
    end

    def must_have_content(content, **)
      ctx.assert target.has_content?(content, **),
                 "Expected page to have content '#{content}'"
    end

    def must_have_selector(selector, **)
      ctx.assert target.has_selector?(selector, **),
                 "Expected page to have selector '#{selector}'"
    end

    def wont_have_css(selector, **)
      ctx.refute target.has_css?(selector, **),
                 "Expected page NOT to have CSS '#{selector}'"
    end

    def wont_have_content(content, **)
      ctx.refute target.has_content?(content, **),
                 "Expected page NOT to have content '#{content}'"
    end
  end
end

# Provide feature/scenario DSL for Capybara feature tests
# This replaces the minitest-rails-capybara gem which is no longer maintained
class CapybaraFeatureTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  # Clean up Capybara session after each test
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    super
  end
end

# Define feature and scenario as top-level methods for DSL syntax
def feature(name, &)
  klass = Class.new(CapybaraFeatureTest) do
    class << self
      attr_accessor :feature_name
    end
  end
  klass.feature_name = name
  Object.const_set("Feature#{name.gsub(/\W+/, '_').camelize}Test", klass)
  klass.class_eval(&)
end

def scenario(name, &)
  define_method("test_#{name.gsub(/\W+/, '_')}", &)
end
