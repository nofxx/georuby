module GeoRuby
  module SimpleFeatures
    %w(
      geometry
      circle
      envelope
      ewkb_parser
      ewkt_parser
      geometry_collection
      geometry_factory
      helper
      line_string
      linear_ring
      multi_line_string
      multi_point
      multi_polygon
      point
      polygon
    ).each do |rel_file|
      require File.join(File.dirname(__FILE__), 'simple_features', rel_file)
    end
  end
end
