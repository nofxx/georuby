require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::Envelope do
  before(:each) do
    @srid = 4269
    @env = GeoRuby::SimpleFeatures::Envelope.from_points([GeoRuby::SimpleFeatures::Point.from_x_y(10,20, @srid),GeoRuby::SimpleFeatures::Point.from_x_y(20,30, @srid)], @srid)
  end

  it "should initialize" do
    expect(@env).to be_instance_of(GeoRuby::SimpleFeatures::Envelope)
  end

  it "converted tu" do
    linear_ring = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],256)
    polygon = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([linear_ring],256)
    e = polygon.envelope

    expect(e.lower_corner.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(e.upper_corner.class).to eql(GeoRuby::SimpleFeatures::Point)

    expect(e.lower_corner.x).to eql(4.456)
    expect(e.lower_corner.y).to eql(-45.3)
    expect(e.upper_corner.x).to eql(45.4)
    expect(e.upper_corner.y).to eql(41.6)

    line_string = GeoRuby::SimpleFeatures::LineString.from_coordinates([[13.6,-49.3],[45.4,44.6],[14.2,1.09],[13.6,-49.3]],256)
    e2 = line_string.envelope

    e3 = e.extend(e2)

    expect(e3.lower_corner.x).to eql(4.456)
    expect(e3.lower_corner.y).to eql(-49.3)
    expect(e3.upper_corner.x).to eql(45.4)
    expect(e3.upper_corner.y).to eql(44.6)
  end

  it "should have a center" do
    expect(@env.center.x).to eql(15)
    expect(@env.center.y).to eql(25)
    expect(@env.center.srid).to eql(@env.srid)
  end

  it "should print a kml_representation" do
    expect(@env.as_kml).to eql("<LatLonAltBox>\n<north>30</north>\n<south>20</south>\n<east>20</east>\n<west>10</west>\n</LatLonAltBox>\n")
  end

end
