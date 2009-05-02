require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Geometry do
  before(:each) do
    @geo = Geometry.new
  end

  it "should instantiate" do
    violated unless @geo
  end

  it "should have a default srid" do
    @geo.srid.should eql(@@srid) #Geometry.default_srid)
  end

  it "should change srid" do
    geo = Geometry.new(225)
    geo.srid.should eql(225)
  end

  it "should instantiate from hex ewkb" do
    point = Geometry.from_hex_ewkb("01010000207B000000CDCCCCCCCCCC28406666666666A64640")
    point.class.should == Point
    point.x.should be_close(12.4, 0.1)
  end

  it "should output as_ewkb" do
    @geo.stub!(:binary_geometry_type).and_return(1)
    @geo.stub!(:binary_representation).and_return(1)
    @geo.as_ewkb.should eql("\001\001\000\000 \346\020\000\000\001")
  end
end
