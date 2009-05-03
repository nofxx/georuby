# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{georuby}
  s.version = "1.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guilhem Vellut", "Marcos Augusto"]
  s.date = %q{2009-05-02}
  s.description = %q{GeoRuby provides geometric data types from the OGC 'Simple Features' specification.}
  s.email = %q{x@nofxx.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.txt"
  ]
  s.files = [
    "History.txt",
    "LICENSE",
    "README.txt",
    "Rakefile",
    "VERSION.yml",
    "lib/geo_ruby.rb",
    "lib/geo_ruby/shp4r/dbf.rb",
    "lib/geo_ruby/shp4r/shp.rb",
    "lib/geo_ruby/simple_features/envelope.rb",
    "lib/geo_ruby/simple_features/ewkb_parser.rb",
    "lib/geo_ruby/simple_features/ewkt_parser.rb",
    "lib/geo_ruby/simple_features/geometry.rb",
    "lib/geo_ruby/simple_features/geometry_collection.rb",
    "lib/geo_ruby/simple_features/geometry_factory.rb",
    "lib/geo_ruby/simple_features/georss_parser.rb",
    "lib/geo_ruby/simple_features/helper.rb",
    "lib/geo_ruby/simple_features/line_string.rb",
    "lib/geo_ruby/simple_features/linear_ring.rb",
    "lib/geo_ruby/simple_features/multi_line_string.rb",
    "lib/geo_ruby/simple_features/multi_point.rb",
    "lib/geo_ruby/simple_features/multi_polygon.rb",
    "lib/geo_ruby/simple_features/point.rb",
    "lib/geo_ruby/simple_features/polygon.rb",
    "spec/data/multipoint.dbf",
    "spec/data/multipoint.shp",
    "spec/data/multipoint.shx",
    "spec/data/point.dbf",
    "spec/data/point.shp",
    "spec/data/point.shx",
    "spec/data/polygon.dbf",
    "spec/data/polygon.shp",
    "spec/data/polygon.shx",
    "spec/data/polyline.dbf",
    "spec/data/polyline.shp",
    "spec/data/polyline.shx",
    "spec/geo_ruby/shp4r/shp_spec.rb",
    "spec/geo_ruby/simple_features/envelope_spec.rb",
    "spec/geo_ruby/simple_features/ewkb_parser_spec.rb",
    "spec/geo_ruby/simple_features/ewkt_parser_spec.rb",
    "spec/geo_ruby/simple_features/geometry_collection_spec.rb",
    "spec/geo_ruby/simple_features/geometry_factory_spec.rb",
    "spec/geo_ruby/simple_features/geometry_spec.rb",
    "spec/geo_ruby/simple_features/georss_parser_spec.rb",
    "spec/geo_ruby/simple_features/line_string_spec.rb",
    "spec/geo_ruby/simple_features/linear_ring_spec.rb",
    "spec/geo_ruby/simple_features/multi_line_string_spec.rb",
    "spec/geo_ruby/simple_features/multi_point_spec.rb",
    "spec/geo_ruby/simple_features/multi_polygon_spec.rb",
    "spec/geo_ruby/simple_features/point_spec.rb",
    "spec/geo_ruby/simple_features/polygon_spec.rb",
    "spec/geo_ruby_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nofxx/georuby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Ruby data holder for OGC Simple Features}
  s.test_files = [
    "spec/geo_ruby/shp4r/shp_spec.rb",
    "spec/geo_ruby/simple_features/polygon_spec.rb",
    "spec/geo_ruby/simple_features/linear_ring_spec.rb",
    "spec/geo_ruby/simple_features/geometry_factory_spec.rb",
    "spec/geo_ruby/simple_features/geometry_spec.rb",
    "spec/geo_ruby/simple_features/georss_parser_spec.rb",
    "spec/geo_ruby/simple_features/multi_point_spec.rb",
    "spec/geo_ruby/simple_features/ewkt_parser_spec.rb",
    "spec/geo_ruby/simple_features/line_string_spec.rb",
    "spec/geo_ruby/simple_features/multi_line_string_spec.rb",
    "spec/geo_ruby/simple_features/geometry_collection_spec.rb",
    "spec/geo_ruby/simple_features/ewkb_parser_spec.rb",
    "spec/geo_ruby/simple_features/multi_polygon_spec.rb",
    "spec/geo_ruby/simple_features/point_spec.rb",
    "spec/geo_ruby/simple_features/envelope_spec.rb",
    "spec/geo_ruby_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
