require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::MultiPolygon do

   it "test_multi_polygon_creation" do
    multi_polygon1 = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)],256)
    multi_polygon1.should be_instance_of(GeoRuby::SimpleFeatures::MultiPolygon)
    multi_polygon1.length.should eql(2)
    multi_polygon1[0].should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)

    multi_polygon2 = GeoRuby::SimpleFeatures::MultiPolygon.from_coordinates([[[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],[[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]]],256)
    multi_polygon1.should be_instance_of(GeoRuby::SimpleFeatures::MultiPolygon)
    multi_polygon1.length.should eql(2)

    multi_polygon2[0].should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
    multi_polygon1.should == multi_polygon2
  end

  it "test_multi_polygon_binary" do
    multi_polygon = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)],256)
    multi_polygon.as_hex_ewkb.should eql("0106000020000100000200000001030000000200000004000000CDCCCCCCCCCC28406666666666A646C03333333333B34640CDCCCCCCCCCC44406DE7FBA9F1D211403D2CD49AE61DF13FCDCCCCCCCCCC28406666666666A646C004000000333333333333034033333333333315409A999999999915408A8EE4F21FD2F63FEC51B81E85EB2C40F6285C8FC2F5F03F3333333333330340333333333333154001030000000200000005000000000000000000000000000000000000000000000000001040000000000000000000000000000010400000000000001040000000000000000000000000000010400000000000000000000000000000000005000000000000000000F03F000000000000F03F0000000000000840000000000000F03F00000000000008400000000000000840000000000000F03F0000000000000840000000000000F03F000000000000F03F")

    multi_polygon = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3,1.2],[45.4,41.6,1.2],[4.456,1.0698,1.2],[12.4,-45.3,1.2]],[[2.4,5.3,1.2],[5.4,1.4263,1.2],[14.46,1.06,1.2],[2.4,5.3,1.2]]],256,false,true),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,1.2],[4,0,1.2],[4,4,2.3],[0,4,1.2],[0,0,1.2]],[[1,1,2.2],[3,1,3.3],[3,3,1.1],[1,3,2.4],[1,1,2.2]]],256,false,true)],256,false,true)
    multi_polygon.as_hex_ewkb.should eql("0106000020000100000200000001030000400200000004000000CDCCCCCCCCCC28406666666666A646C0333333333333F33F3333333333B34640CDCCCCCCCCCC4440333333333333F33F6DE7FBA9F1D211403D2CD49AE61DF13F333333333333F33FCDCCCCCCCCCC28406666666666A646C0333333333333F33F0400000033333333333303403333333333331540333333333333F33F9A999999999915408A8EE4F21FD2F63F333333333333F33FEC51B81E85EB2C40F6285C8FC2F5F03F333333333333F33F33333333333303403333333333331540333333333333F33F0103000040020000000500000000000000000000000000000000000000333333333333F33F00000000000010400000000000000000333333333333F33F00000000000010400000000000001040666666666666024000000000000000000000000000001040333333333333F33F00000000000000000000000000000000333333333333F33F05000000000000000000F03F000000000000F03F9A999999999901400000000000000840000000000000F03F6666666666660A40000000000000084000000000000008409A9999999999F13F000000000000F03F00000000000008403333333333330340000000000000F03F000000000000F03F9A99999999990140")
  end

  it "test_multi_polygon_text" do
    multi_polygon = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)],256)
    multi_polygon.as_ewkt.should eql("SRID=256;MULTIPOLYGON(((12.4 -45.3,45.4 41.6,4.456 1.0698,12.4 -45.3),(2.4 5.3,5.4 1.4263,14.46 1.06,2.4 5.3)),((0 0,4 0,4 4,0 4,0 0),(1 1,3 1,3 3,1 3,1 1)))")

    multi_polygon = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3,2],[45.4,41.6,3],[4.456,1.0698,4],[12.4,-45.3,2]],[[2.4,5.3,1],[5.4,1.4263,3.44],[14.46,1.06,4.5],[2.4,5.3,1]]],4326,true),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,5.6],[4,0,5.4],[4,4,1],[0,4,23],[0,0,5.6]],[[1,1,2.3],[3,1,4],[3,3,5],[1,3,6],[1,1,2.3]]],4326,true)],4326,true)
    multi_polygon.as_ewkt.should eql("SRID=4326;MULTIPOLYGON(((12.4 -45.3 2,45.4 41.6 3,4.456 1.0698 4,12.4 -45.3 2),(2.4 5.3 1,5.4 1.4263 3.44,14.46 1.06 4.5,2.4 5.3 1)),((0 0 5.6,4 0 5.4,4 4 1,0 4 23,0 0 5.6),(1 1 2.3,3 1 4,3 3 5,1 3 6,1 1 2.3)))")
  end

  describe "Counting" do

    before do
      @mp = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)],256)
    end

    it "should have a points method" do
      @mp.points[0].should be_instance_of(GeoRuby::SimpleFeatures::Point)
    end

    it "should flatten it right" do
      @mp.should have(18).points
    end

  end
end
