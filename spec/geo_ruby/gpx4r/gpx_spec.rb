require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::Gpx4r do

  it "should add gpx extension and raise if doesn't exists" do
    expect do
      expect(File).to receive(:exists?).with("short.gpx").and_return(false)
      expect(GeoRuby::Gpx4r::GpxFile.open('short')).to be_truthy
    end.to raise_error GeoRuby::Gpx4r::MalformedGpxException
  end

  describe "Waypoints" do

    before(:all) do
      @gpxfile = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/short.gpx', :with_z => true, :with_m => true)
      @gpxfile2 = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/fells_loop', :with_z => true, :with_m => true)
      @gpxfile3 = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/tracktreks.gpx', :with_z => true)
    end

    it "should open and parse" do
      expect(@gpxfile.record_count).to eql(2724)
    end

    it "should open and parse no trkpt one" do
      expect(@gpxfile2.record_count).to eql(86)
    end

    it "should open and parse 3" do
      expect(@gpxfile3.record_count).to eql(225)
    end

    it "should read X and Y" do
      expect(@gpxfile[0].x).to be_within(0.0001).of(9.093942)
      expect(@gpxfile[0].y).to be_within(0.0001).of(48.731813)
    end

    it "should read Z and M" do
      expect(@gpxfile[0].z).to eql(468.0)
      expect(@gpxfile[0].m).to eql("2008-09-07T17:36:57Z")
    end

    it "should read X and Y 2" do
      expect(@gpxfile2[0].x).to be_within(0.0001).of(-71.119277)
      expect(@gpxfile2[0].y).to be_within(0.0001).of(42.438878)
    end

    it "should read Z and M 2" do
      expect(@gpxfile2[0].z).to eql(44.586548)
      expect(@gpxfile2[0].m).to eql("2001-11-28T21:05:28Z")
    end

    it "should read X and Y 3" do
      expect(@gpxfile3[0].x).to be_within(0.0001).of(-149.8358011)
      expect(@gpxfile3[0].y).to be_within(0.0001).of(-17.5326508)
    end

    it "should read Z and M 3" do
      expect(@gpxfile3[0].z).to eql(88.5787354)
      expect(@gpxfile3[0].m).to eql(0.0)
    end

    it "should return it as a linestring" do
      expect(@gpxfile.as_line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
      expect(@gpxfile.as_polyline).to be_instance_of GeoRuby::SimpleFeatures::LineString
    end

    it "should return it as a linestring 3" do
      expect(@gpxfile3.as_line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
      expect(@gpxfile3.as_polyline).to be_instance_of GeoRuby::SimpleFeatures::LineString
    end

    it "should return a envelope" do
      expect(@gpxfile.envelope).to be_instance_of GeoRuby::SimpleFeatures::Envelope
      expect(@gpxfile.envelope.lower_corner.x).to be_within(0.001).of(9.08128)
      expect(@gpxfile.envelope.lower_corner.y).to be_within(0.001).of(48.7169)
    end

    it "should return a envelope 3" do
      expect(@gpxfile3.envelope).to be_instance_of GeoRuby::SimpleFeatures::Envelope
      expect(@gpxfile3.envelope.lower_corner.x).to be_within(0.001).of(-149.8422613)
      expect(@gpxfile3.envelope.lower_corner.y).to be_within(0.001).of(-17.547636)
    end

    it "should return it as a polygon" do
      [@gpxfile, @gpxfile2, @gpxfile3].each do |g|
        expect(g.as_polygon).to be_instance_of GeoRuby::SimpleFeatures::Polygon
        expect(g.as_polygon[0]).to be_instance_of GeoRuby::SimpleFeatures::LinearRing
        expect(g.as_polygon[0]).to be_closed
        expect(g.as_polygon[1]).to be_nil
      end
    end

    it "should close the polygon" do
      se = GeoRuby::SimpleFeatures::Point.from_x_y(-44, -23)
      sw = GeoRuby::SimpleFeatures::Point.from_x_y(-42, -22)
      nw = GeoRuby::SimpleFeatures::Point.from_x_y(-42, -25)
      ne = GeoRuby::SimpleFeatures::Point.from_x_y(-44, -21)
      @gpxfile.instance_variable_set(:@points, [se,sw,nw,ne])
      expect(@gpxfile.as_polygon).to eq(GeoRuby::SimpleFeatures::Polygon.from_points([[se,sw,nw,ne,se]]))
    end
  end

end
