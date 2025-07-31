# frozen_string_literal: true

# :nodoc:
module ApplicationHelper
  module_function

  def read_data_file(filename)
    File.foreach(filename).with_object([]) do |line, result|
      result << line.split.map(&:to_s).join(' ').upcase.strip unless line.strip.empty?
    end
  end

  def titleise(orig) # rubocop:disable Metrics/MethodLength
    # Any word with fewer than four letters should remain in lowercase
    # “and”, “but”, “for”, “at,” “by”, “to”, and “from”, except if first or last
    # https://www.grammarly.com/blog/capitalization-in-the-titles/
    not_to_cap = %w[either neither after before above below down from into near
                    onto over past upon with than that till when once where while]
    phrase = orig.dup
    pos = 0
    phrase_length = orig.scan(/(?u)(\w+)/).length
    phrase.gsub!(/(?u)(\w+)/) do |w|
      pos += 1
      if pos == 1 || pos == phrase_length || (
          w.length > 3 && not_to_cap.exclude?(w.downcase)
        )
        w.capitalize
      else
        w.downcase
      end
    end
    phrase
  end
end
