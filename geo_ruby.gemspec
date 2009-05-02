# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geo_ruby}
  s.version = "1.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcos Augusto"]
  s.date = %q{2009-05-02}
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
    "lib/geo_ruby/base/envelope.rb",
    "lib/geo_ruby/base/ewkb_parser.rb",
    "lib/geo_ruby/base/ewkt_parser.rb",
    "lib/geo_ruby/base/geometry.rb",
    "lib/geo_ruby/base/geometry_collection.rb",
    "lib/geo_ruby/base/geometry_factory.rb",
    "lib/geo_ruby/base/georss_parser.rb",
    "lib/geo_ruby/base/helper.rb",
    "lib/geo_ruby/base/line_string.rb",
    "lib/geo_ruby/base/linear_ring.rb",
    "lib/geo_ruby/base/multi_line_string.rb",
    "lib/geo_ruby/base/multi_point.rb",
    "lib/geo_ruby/base/multi_polygon.rb",
    "lib/geo_ruby/base/multi_polygon_flymake.rb",
    "lib/geo_ruby/base/point.rb",
    "lib/geo_ruby/base/polygon.rb",
    "lib/geo_ruby/shp4r/dbf.rb",
    "lib/geo_ruby/shp4r/shp.rb",
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
    "spec/geo_ruby/base/envelope_spec.rb",
    "spec/geo_ruby/base/ewkb_parser_spec.rb",
    "spec/geo_ruby/base/ewkt_parser_spec.rb",
    "spec/geo_ruby/base/geometry_collection_spec.rb",
    "spec/geo_ruby/base/geometry_factory_spec.rb",
    "spec/geo_ruby/base/geometry_spec.rb",
    "spec/geo_ruby/base/georss_parser_spec.rb",
    "spec/geo_ruby/base/line_string_spec.rb",
    "spec/geo_ruby/base/linear_ring_spec.rb",
    "spec/geo_ruby/base/multi_line_string_spec.rb",
    "spec/geo_ruby/base/multi_point_spec.rb",
    "spec/geo_ruby/base/multi_polygon_spec.rb",
    "spec/geo_ruby/base/point_spec.rb",
    "spec/geo_ruby/base/polygon_spec.rb",
    "spec/geo_ruby/shp4r/shp_spec.rb",
    "spec/geo_ruby_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nofxx/geo_ruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{GeoRuby fork}
  s.test_files = [
    "spec/geo_ruby/shp4r/shp_spec.rb",
    "spec/geo_ruby/base/polygon_spec.rb",
    "spec/geo_ruby/base/linear_ring_spec.rb",
    "spec/geo_ruby/base/geometry_factory_spec.rb",
    "spec/geo_ruby/base/geometry_spec.rb",
    "spec/geo_ruby/base/georss_parser_spec.rb",
    "spec/geo_ruby/base/multi_point_spec.rb",
    "spec/geo_ruby/base/ewkt_parser_spec.rb",
    "spec/geo_ruby/base/line_string_spec.rb",
    "spec/geo_ruby/base/multi_line_string_spec.rb",
    "spec/geo_ruby/base/geometry_collection_spec.rb",
    "spec/geo_ruby/base/ewkb_parser_spec.rb",
    "spec/geo_ruby/base/multi_polygon_spec.rb",
    "spec/geo_ruby/base/point_spec.rb",
    "spec/geo_ruby/base/envelope_spec.rb",
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
