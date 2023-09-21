# frozen_string_literal: true

module Version
  MAJOR = 1
  MINOR = 5
  PATCH = 0
  SUFFIX = 1
  VERSION = "#{MAJOR}.#{MINOR}.#{PATCH}#{SUFFIX && ".#{SUFFIX}"}"
end
