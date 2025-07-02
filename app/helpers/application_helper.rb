# frozen_string_literal: true

# :nodoc:
module ApplicationHelper
  module_function

  def read_data_file(filename)
    File.foreach(filename).with_object([]) do |line, result|
      result << line.split.map(&:to_s).join(' ').upcase.strip unless line.strip.empty?
    end
  end
end
