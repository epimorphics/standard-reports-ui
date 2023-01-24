# frozen_string_literal: true

module Version
  MAJOR = 1
  MINOR = 4
  PATCH = 2
  SUFFIX = nil
  VERSION = "#{MAJOR}.#{MINOR}.#{PATCH}#{SUFFIX && ".#{SUFFIX}"}"
end
