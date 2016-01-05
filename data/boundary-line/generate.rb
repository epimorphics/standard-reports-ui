#!/usr/bin/ruby

# Generate simplified boundary lines for counties and regions

require 'rgeo/shapefile'
require 'byebug'

COUNTY_SOURCE = './Data/GB/county_region.shp'
DISTRICT_SOURCE = './Data/GB/district_borough_unitary_region.shp'
EURO_REGION_SOURCE = './Data/GB/european_region_region.shp'

def as_keys( name )
  name
    .gsub( /County\Z/, "" )
    .gsub( /\ACounty of/, "" )
    .gsub( /\(B\)/, "" )
    .gsub( /The City Of/i, "" )
    .gsub( /City Of/i, "" )
    .gsub( /euro region/i, "" )
    .strip
    .upcase
    .split( " - " )
end

def create_index( filename, index = Hash.new )
  RGeo::Shapefile::Reader.open( filename ) do |file|
    file.each do |record|
      name = record.attributes["NAME"]
      as_keys( name ).each do |key|
        index[key] = record
      end
    end
  end

  index
end

puts "Start indexing"
index = create_index( DISTRICT_SOURCE )
puts " ... done districts (#{index.keys.length})"
create_index( COUNTY_SOURCE, index )
puts " ... done counties (#{index.keys.length})"
create_index( EURO_REGION_SOURCE, index )
puts " ... done Euro regions (#{index.keys.length})"

counties = File.read( "../county-names.txt" ).split( "\n" ).map {|c| c.gsub( /CITY OF /, "" )}
puts "Checking #{counties.length} counties .."

part = counties.partition {|c| index.has_key?( c )}

puts index.keys.inspect
puts "-----"
puts "Found #{part[0].length}:\n #{part[0].inspect}"
puts "Not found #{part[1].length}:\n #{part[1].inspect}"
