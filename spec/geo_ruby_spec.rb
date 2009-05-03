require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Time to add your specs!
# http://rspec.info/
describe "GeoRuby Stuff" do

  it "should instantiate Geometry" do
    @geo = GeoRuby::SimpleFeatures::Geometry.new
    @geo.class.should eql(Geometry)
  end

  it "should instantiate from SimpleFeatures for compatibility" do
    @geo = GeoRuby::SimpleFeatures::Geometry.new
    @geo.class.should eql(Geometry)
  end

  it "should instantiate Point" do
    @point = Point.new
    @point.should be_instance_of(Point)
  end

  it "should instantiate Line" do
    @line = LineString.new
    @line.should be_instance_of(LineString)
  end

end
