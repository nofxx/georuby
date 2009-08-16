require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include GeoRuby::Gpx4r
include GeoRuby::SimpleFeatures

describe Gpx4r do

  describe "Waypoints" do
    before(:all) do
      @gpxfile = GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/short.gpx')
    end

    it "should open and parse" do
      @gpxfile.record_count.should eql(2724)
    end

    it "should not be empty" do
      @gpxfile.should_not be_empty
    end

    it "should open w/o shp extension" do
      GpxFile.open(File.dirname(__FILE__) + '/../../data/gpx/short').should be_true
    end

    it "should read X and Y" do
      @gpxfile[0].x.should be_close(9.093942, 0.0001)
      @gpxfile[0].y.should be_close(48.731813, 0.0001)
    end

    it "should read Z and M" do
      @gpxfile[0].z.should eql(468)
      @gpxfile[0].m.should eql("2008-09-07T17:36:57Z")
    end

    it "should return it as a linestring" do
      @gpxfile.as_line_string.should be_instance_of LineString
      @gpxfile.as_polyline.should be_instance_of LineString
    end

    it "should return it as a polygon" do
      @gpxfile.as_polygon.should be_instance_of Polygon
    end

    it "should return a envelope" do
      @gpxfile.envelope.should be_instance_of Envelope
      @gpxfile.envelope.lower_corner.x.should be_close(9.08128, 0.001)
      @gpxfile.envelope.lower_corner.y.should be_close(48.7169, 0.001)
    end
  end
end
