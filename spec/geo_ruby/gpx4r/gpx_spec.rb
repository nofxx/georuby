require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::Gpx4r do

  it "should add gpx extension and raise if doesn't exists" do
    lambda do
      File.should_receive(:exists?).with("short.gpx").and_return(false)
      GeoRuby::Gpx4r::GpxFile.open('short').should be_true
    end.should raise_error GeoRuby::Gpx4r::MalformedGpxException
  end

  describe "Waypoints" do

    before(:all) do
      @gpxfile = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/short.gpx', :with_z => true, :with_m => true)
      @gpxfile2 = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/fells_loop', :with_z => true, :with_m => true)
      @gpxfile3 = GeoRuby::Gpx4r::GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/tracktreks.gpx', :with_z => true)
    end

    it "should open and parse" do
      @gpxfile.record_count.should eql(2724)
    end

    it "should open and parse no trkpt one" do
      @gpxfile2.record_count.should eql(86)
    end

    it "should open and parse 3" do
      @gpxfile3.record_count.should eql(225)
    end

    it "should read X and Y" do
      @gpxfile[0].x.should be_within(0.0001).of(9.093942)
      @gpxfile[0].y.should be_within(0.0001).of(48.731813)
    end

    it "should read Z and M" do
      @gpxfile[0].z.should eql(468.0)
      @gpxfile[0].m.should eql("2008-09-07T17:36:57Z")
    end

    it "should read X and Y 2" do
      @gpxfile2[0].x.should be_within(0.0001).of(-71.119277)
      @gpxfile2[0].y.should be_within(0.0001).of(42.438878)
    end

    it "should read Z and M 2" do
      @gpxfile2[0].z.should eql(44.586548)
      @gpxfile2[0].m.should eql("2001-11-28T21:05:28Z")
    end

    it "should read X and Y 3" do
      @gpxfile3[0].x.should be_within(0.0001).of(-149.8358011)
      @gpxfile3[0].y.should be_within(0.0001).of(-17.5326508)
    end

    it "should read Z and M 3" do
      @gpxfile3[0].z.should eql(88.5787354)
      @gpxfile3[0].m.should eql(0.0)
    end

    it "should return it as a linestring" do
      @gpxfile.as_line_string.should be_instance_of GeoRuby::SimpleFeatures::LineString
      @gpxfile.as_polyline.should be_instance_of GeoRuby::SimpleFeatures::LineString
    end

    it "should return it as a linestring 3" do
      @gpxfile3.as_line_string.should be_instance_of GeoRuby::SimpleFeatures::LineString
      @gpxfile3.as_polyline.should be_instance_of GeoRuby::SimpleFeatures::LineString
    end

    it "should return a envelope" do
      @gpxfile.envelope.should be_instance_of GeoRuby::SimpleFeatures::Envelope
      @gpxfile.envelope.lower_corner.x.should be_within(0.001).of(9.08128)
      @gpxfile.envelope.lower_corner.y.should be_within(0.001).of(48.7169)
    end

    it "should return a envelope 3" do
      @gpxfile3.envelope.should be_instance_of GeoRuby::SimpleFeatures::Envelope
      @gpxfile3.envelope.lower_corner.x.should be_within(0.001).of(-149.8422613)
      @gpxfile3.envelope.lower_corner.y.should be_within(0.001).of(-17.547636)
    end

    it "should return it as a polygon" do
      [@gpxfile, @gpxfile2, @gpxfile3].each do |g|
        g.as_polygon.should be_instance_of GeoRuby::SimpleFeatures::Polygon
        g.as_polygon[0].should be_instance_of GeoRuby::SimpleFeatures::LinearRing
        g.as_polygon[0].should be_closed
        g.as_polygon[1].should be_nil
      end
    end

    it "should close the polygon" do
      se = GeoRuby::SimpleFeatures::Point.from_x_y(-44, -23)
      sw = GeoRuby::SimpleFeatures::Point.from_x_y(-42, -22)
      nw = GeoRuby::SimpleFeatures::Point.from_x_y(-42, -25)
      ne = GeoRuby::SimpleFeatures::Point.from_x_y(-44, -21)
      @gpxfile.instance_variable_set(:@points, [se,sw,nw,ne])
      @gpxfile.as_polygon.should == GeoRuby::SimpleFeatures::Polygon.from_points([[se,sw,nw,ne,se]])
    end
  end

end
