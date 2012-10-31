require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Time to add your specs!
# http://rspec.info/
describe GeoRuby do
  
  it "should instantiate Geometry" do
    @geo = GeoRuby::SimpleFeatures::Geometry.new
    @geo.class.should eql(::GeoRuby::SimpleFeatures::Geometry)
  end

  it "should instantiate Point" do
    @point = GeoRuby::SimpleFeatures::Point.new
    @point.should be_instance_of(::GeoRuby::SimpleFeatures::Point)
  end

  it "should instantiate Line" do
    @line = GeoRuby::SimpleFeatures::LineString.new
    @line.should be_instance_of(::GeoRuby::SimpleFeatures::LineString)
  end

end
