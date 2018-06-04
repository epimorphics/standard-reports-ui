#!/usr/bin/ruby
# frozen_string_literal: true

# Generator script to convert the region, county, etc, names that @DaveReynolds
# extracted from the triple store into a JavaScript object that we can use in
# client-side code.

def file_header
  <<~EOF
    window.lr = window.lr || {};
    window.lr.data = (function() {
      "use strict";
      return {
EOF
end

def file_footer
  <<~EOF
      };
    })();
EOF
end

def transcribe_file(output, key, datafile)
  output << "  #{key}: ["
  open(datafile).each_with_index do |name, i|
    output << ', ' unless i == 0
    output << formatted_name(name.strip)
  end
  output << '  ]'
end

def formatted_name(name)
  " {value: #{name.inspect}, label: #{label_for(name).inspect}}"
end

def label_for(name)
  name
    .split(' ')
    .map(&:capitalize)
    .join(' ')
end

file = ARGV[1] || '../app/assets/javascripts/data.js'
geographies = %i[county district region]

File.open(file, 'w') do |f|
  f << file_header
  geographies.each_with_index do |geography, i|
    transcribe_file(f, geography, "#{geography}-names.txt")
    f << (i == geographies.length - 1 ? "\n" : ",\n")
  end
  f << file_footer
end
