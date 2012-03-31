#
# Just for fun, benchmarking Pure Ruby GeoRuby against RGeo.
#
#!/usr/bin/env ruby
require "benchmark"

require "geo_ruby"
require "rgeo"

COUNT = 100000

fac = RGeo::Cartesian.factory

def t text
  puts "\n\n#{' ' * (53-text.size)}#{text}\n"
end

t "Point.new!"
Benchmark.bmbm do |x|
  x.report("Georuby") { COUNT.times { x = GeoRuby::SimpleFeatures::Point.from_x_y(1, 1) } }
  x.report("RGeo")    { COUNT.times { x = fac.point(1, 1) } }
end

t "Point.xy!"
gpoint, rpoint = GeoRuby::SimpleFeatures::Point.from_x_y(1, 1), fac.point(1, 1)
Benchmark.bmbm do |x|
  x.report("Georuby") { COUNT.times { x,y = gpoint.x, gpoint.y } }
  x.report("RGeo")    { COUNT.times { x,y = rpoint.x, rpoint.y } }
end

t "Distance Haversine Formula"
Benchmark.bmbm do |x|
  x.report("Georuby") { COUNT.times { x = GeoRuby::SimpleFeatures::Point.from_x_y(1, 1); x.spherical_distance(x) } }
  x.report("RGeo")    { COUNT.times { x = fac.point(1, 1);x.distance(x) } }
end
