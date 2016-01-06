#!/usr/bin/ruby

# Generate simplified boundary lines for counties and regions
require 'bundler'
require 'json'
Bundler.require

TARGET_COUNTY_NAMES = "../county-names.txt"

COUNTY_SOURCE = "./Data/GB/county_region.shp"
DISTRICT_SOURCE = "./Data/GB/district_borough_unitary_region.shp"
EURO_REGION_SOURCE = "./Data/GB/european_region_region.shp"
CEREMONIAL_SOURCE = "./Data/Supplementary_Ceremonial/Boundary-line-ceremonial-counties.shp"

SIMPLIFICATION = 40

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

def simplify_line( line )
  puts( "Starting simplify, #points = #{line.length}")
  xy = to_xy( line )
  simplified = SimplifyRb.simplify( xy, SIMPLIFICATION, true )
  puts( " .. done simplify, #points = #{simplified.length}")
  from_xy( simplified )
end

def to_xy( line )
  line.map {|p| {x: p[0].round(3), y: p[1].round(3)}}
end

def from_xy( line )
  line.map {|p| [p[:x], p[:y]]}
end

def as_geojson_feature( record )
  name = record.attributes["NAME"] || record.attributes["Name"]
  RGeo::GeoJSON::Feature.new( record.geometry, name )
end

def is_point?( p )
  p.is_a?( Array ) &&
  (p.length == 2 || p.length == 4) &&
  (p[0].is_a? Numeric) &&
  (p[1].is_a? Numeric)
end

def is_line?( a )
  a.is_a?( Array ) &&
  a.all? {|v| is_point?( v )}
end

def simplify_lines( a )
  byebug unless a.is_a?( Array )
  a.map do |a_value|
    if is_line?( a_value )
      simplify_line( a_value )
    else
      simplify_lines( a_value )
    end
  end
end

def load_json
  File.exist?( "fc.json" ) && JSON.load( File.open( "fc.json" ) )
end

json = load_json
if json
  puts "Loaded json"
else
  puts "Start indexing"
  index = composite_index
  puts "Done indexing, generating features"

  features = target_counties.map do |county_name|
    as_geojson_feature( as_geo_record( county_name, index ) )
  end

  puts "Done feature generation, generating collection"
  fc = RGeo::GeoJSON::FeatureCollection.new( features )

  puts "Done collecting, starting encoding"
  json = RGeo::GeoJSON.encode( fc )
end


puts "Simplifying"

j_features = json["features"]
j_features.each do |feature|
  geometry = feature["geometry"]
  coords = geometry["coordinates"]
  s_coords = simplify_lines( coords )
  geometry["coordinates"] = s_coords
end

File.open( "fc_simple.json", "w" ) do |file|
  file << json.to_json
  file.flush
end

puts "Done."
