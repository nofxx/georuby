require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Envelope do
  before(:each) do
    @env = Envelope.from_points([Point.from_x_y(10,20),Point.from_x_y(20,30)])
  end

  it "should initialize" do
    @env.should be_instance_of(Envelope)
  end

  it "converted tu" do
    linear_ring = LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],256)
    polygon = Polygon.from_linear_rings([linear_ring],256)
    e = polygon.envelope

    e.lower_corner.class.should eql(Point)
    e.upper_corner.class.should eql(Point)

    e.lower_corner.x.should eql(4.456)
    e.lower_corner.y.should eql(-45.3)
    e.upper_corner.x.should eql(45.4)
    e.upper_corner.y.should eql(41.6)

    line_string = LineString.from_coordinates([[13.6,-49.3],[45.4,44.6],[14.2,1.09],[13.6,-49.3]],256)
    e2 = line_string.envelope

    e3 = e.extend(e2)

    e3.lower_corner.x.should eql(4.456)
    e3.lower_corner.y.should eql(-49.3)
    e3.upper_corner.x.should eql(45.4)
    e3.upper_corner.y.should eql(44.6)
  end

  it "should have a center" do
    @env.center.x.should eql(15)
    @env.center.y.should eql(25)
  end

  it "should print a kml_representation" do
    @env.as_kml.should eql("<LatLonAltBox>\n<north>30</north>\n<south>20</south>\n<east>20</east>\n<west>10</west>\n</LatLonAltBox>\n")
  end

end
