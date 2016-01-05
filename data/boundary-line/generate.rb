#!/usr/bin/ruby

# Generate simplified boundary lines for counties and regions
require 'bundler'
Bundler.require

TARGET_COUNTY_NAMES = "../county-names.txt"

COUNTY_SOURCE = "./Data/GB/county_region.shp"
DISTRICT_SOURCE = "./Data/GB/district_borough_unitary_region.shp"
EURO_REGION_SOURCE = "./Data/GB/european_region_region.shp"
CEREMONIAL_SOURCE = "./Data/Supplementary_Ceremonial/Boundary-line-ceremonial-counties.shp"

def as_keys( name )
  name
    .gsub( /County\Z/, "" )
    .gsub( /\ACounty of/, "" )
    .gsub( /\(B\)/, "" )
    .gsub( /The City Of/i, "" )
    .gsub( /City Of/i, "" )
    .gsub( /euro region/i, "" )
    .gsub( /\&/, "and" )
    .strip
    .upcase
    .split( " - " )
end

def create_index( filename, index = Hash.new )
  RGeo::Shapefile::Reader.open( filename ) do |file|
    file.each do |record|
      name = record.attributes["NAME"] || record.attributes["Name"]
      as_keys( name ).each do |key|
        index[key] = record
      end
    end
  end

  index
end

def composite_index
  create_index(
    CEREMONIAL_SOURCE,
    create_index(
      EURO_REGION_SOURCE,
      create_index(
        COUNTY_SOURCE,
        create_index( DISTRICT_SOURCE ) )))
end

def normalize_county_name( name )
  name
    .upcase
    .gsub( /CITY OF /, "" )
    .gsub( /RHONDDA CYNON TAFF/, "RHONDDA CYNON TAF")
    .gsub( /\AWREKIN\Z/, "TELFORD AND WREKIN")
end

def target_counties
  File
    .read( TARGET_COUNTY_NAMES )
    .split( "\n" )
    .map &method(:normalize_county_name)
end

def as_geo_record( name, index )
  index[name] || raise( "No data for '#{name}'")
end

def simplify_geometry( geometry )
  geometry
end

def as_geojson_feature( record )
  name = record.attributes["NAME"] || record.attributes["Name"]
  RGeo::GeoJSON::Feature.new( simplify_geometry( record.geometry ), name )
end

puts "Start indexing"
index = composite_index
puts "Done indexing, generating features"

features = target_counties.map do |county_name|
  as_geojson_feature( as_geo_record( county_name, index ) )
end

puts "Done feature generation, generating collection"
fc = RGeo::GeoJSON::FeatureCollection.new( features )

puts "Done collecting, starting encoding"

byebug

File.open( "fc.json", "w" ) do |file|
  file << RGeo::GeoJSON.encode( fc ).to_json
end

puts "Done."
