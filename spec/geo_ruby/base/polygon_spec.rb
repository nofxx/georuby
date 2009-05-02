require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Polygon do

  describe "tu conveted" do
    #no test of the binary representation for linear_rings : always with polygons and like line_string
    it "should test_polygon_creation" do
      linear_ring1 = LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],256)
      linear_ring2 = LinearRing.from_coordinates([[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]],256)
      point1 = Point.from_x_y(12.4,-45.3,256)
      point2 = Point.from_x_y(45.4,41.6,256)
      point3 = Point.from_x_y(4.456,1.0698,256)
      point4 = Point.from_x_y(12.4,-45.3,256)
      point5 = Point.from_x_y(2.4,5.3,256)
      point6 = Point.from_x_y(5.4,1.4263,256)
      point7 = Point.from_x_y(14.46,1.06,256)
      point8 = Point.from_x_y(2.4,5.3,256)

      polygon = Polygon::new(256)
      polygon.length.should be_zero

      polygon << linear_ring1
      polygon.length.should eql(1)
      polygon[0].should == linear_ring1

      #the validity of the hole is not checked : just for the sake of example
      polygon << linear_ring2
      polygon.length.should eql(2)
      polygon[1].should == linear_ring2

      polygon = Polygon.from_linear_rings([linear_ring1,linear_ring2],256)
      polygon.class.should eql(Polygon)
      polygon.length.should eql(2)
      polygon[0].should == linear_ring1
      polygon[1].should == linear_ring2

      polygon = Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
      polygon.class.should eql(Polygon)
      polygon.length.should eql(2)
      polygon[0].should == linear_ring1
      polygon[1].should == linear_ring2

      polygon = Polygon.from_points([[point1,point2,point3,point4],[point5,point6,point7,point8]],256)
      polygon.length.should eql(2)
      polygon[0].should == linear_ring1
      polygon[1].should == linear_ring2

      polygon = Polygon.from_coordinates([[[12.4,-45.3,15.2],[45.4,41.6,2.4],[4.456,1.0698,5.6],[12.4,-45.3,6.1]],[[2.4,5.3,4.5],[5.4,1.4263,4.2],[14.46,1.06,123.1],[2.4,5.3,4.4]]],256,true)
      polygon.class.should eql(Polygon)
      polygon.length.should eql(2)

      linear_ring1 = LinearRing.from_coordinates([[12.4,-45.3,15.2],[45.4,41.6,2.4],[4.456,1.0698,5.6],[12.4,-45.3,6.1]],256,true)
      linear_ring2 = LinearRing.from_coordinates([[2.4,5.3,4.5],[5.4,1.4263,4.2],[14.46,1.06,123.1],[2.4,5.3,4.4]],256,true)
      polygon[0].should == linear_ring1
      polygon[1].should == linear_ring2
    end

    it "bbox" do
      bbox = Polygon.from_coordinates([[[12.4,-45.3,15.2],[45.4,41.6,2.4],[4.456,1.0698,5.6],[12.4,-45.3,6.1]],[[2.4,5.3,4.5],[5.4,1.4263,4.2],[14.46,1.06,123.1],[2.4,5.3,4.4]]],256,true).bounding_box
      bbox.length.should eql(2)
      bbox[0].should == Point.from_x_y_z(4.456,-45.3,2.4)
      bbox[1].should == Point.from_x_y_z(45.4,41.6,123.1)
    end


    it "test_polygon_equal" do
      polygon1 = Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
      polygon2 = Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06]]])
      point = Point.from_x_y(12.4,-45.3,123)

      polygon1.should  == Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
      polygon1.should_not == polygon2
      polygon1.should_not == point
    end

    it "test_polygon_binary" do
      polygon = Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)
      #taken from PostGIS answer
      polygon.as_hex_ewkb.should eql("0103000020000100000200000005000000000000000000000000000000000000000000000000001040000000000000000000000000000010400000000000001040000000000000000000000000000010400000000000000000000000000000000005000000000000000000F03F000000000000F03F0000000000000840000000000000F03F00000000000008400000000000000840000000000000F03F0000000000000840000000000000F03F000000000000F03F")

      polygon = Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,true)
      #taken from PostGIS answer
      polygon.as_hex_ewkb.should eql("01030000A000010000020000000500000000000000000000000000000000000000000000000000004000000000000010400000000000000000000000000000004000000000000010400000000000001040000000000000004000000000000000000000000000001040000000000000004000000000000000000000000000000000000000000000004005000000000000000000F03F000000000000F03F00000000000000400000000000000840000000000000F03F0000000000000040000000000000084000000000000008400000000000000040000000000000F03F00000000000008400000000000000040000000000000F03F000000000000F03F0000000000000040")

      polygon = Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,false,true)
      polygon.as_hex_ewkb.should eql("010300006000010000020000000500000000000000000000000000000000000000000000000000004000000000000010400000000000000000000000000000004000000000000010400000000000001040000000000000004000000000000000000000000000001040000000000000004000000000000000000000000000000000000000000000004005000000000000000000F03F000000000000F03F00000000000000400000000000000840000000000000F03F0000000000000040000000000000084000000000000008400000000000000040000000000000F03F00000000000008400000000000000040000000000000F03F000000000000F03F0000000000000040")

      polygon = Polygon.from_coordinates([[[0,0,2,-45.1],[4,0,2,5],[4,4,2,4.67],[0,4,2,1.34],[0,0,2,-45.1]],[[1,1,2,12.3],[3,1,2,123],[3,3,2,12.2],[1,3,2,12],[1,1,2,12.3]]],256,true,true)
      polygon.as_hex_ewkb.should eql("01030000E0000100000200000005000000000000000000000000000000000000000000000000000040CDCCCCCCCC8C46C00000000000001040000000000000000000000000000000400000000000001440000000000000104000000000000010400000000000000040AE47E17A14AE1240000000000000000000000000000010400000000000000040713D0AD7A370F53F000000000000000000000000000000000000000000000040CDCCCCCCCC8C46C005000000000000000000F03F000000000000F03F00000000000000409A999999999928400000000000000840000000000000F03F00000000000000400000000000C05E400000000000000840000000000000084000000000000000406666666666662840000000000000F03F000000000000084000000000000000400000000000002840000000000000F03F000000000000F03F00000000000000409A99999999992840")
    end

    it "should test_polygon_text" do
      polygon = Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)
      polygon.as_ewkt.should eql("SRID=256;POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1,3 1,3 3,1 3,1 1))")

      polygon = Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,true)
      polygon.as_ewkt.should eql("SRID=256;POLYGON((0 0 2,4 0 2,4 4 2,0 4 2,0 0 2),(1 1 2,3 1 2,3 3 2,1 3 2,1 1 2))")

      polygon = Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,false,true)
      polygon.as_ewkt.should eql("SRID=256;POLYGONM((0 0 2,4 0 2,4 4 2,0 4 2,0 0 2),(1 1 2,3 1 2,3 3 2,1 3 2,1 1 2))")

      polygon = Polygon.from_coordinates([[[0,0,2,-45.1],[4,0,2,5],[4,4,2,4.67],[0,4,2,1.34],[0,0,2,-45.1]],[[1,1,2,12.3],[3,1,2,123],[3,3,2,12.2],[1,3,2,12],[1,1,2,12.3]]],256,true,true)
      polygon.as_ewkt.should eql("SRID=256;POLYGON((0 0 2 -45.1,4 0 2 5,4 4 2 4.67,0 4 2 1.34,0 0 2 -45.1),(1 1 2 12.3,3 1 2 123,3 3 2 12.2,1 3 2 12,1 1 2 12.3))")
    end

  end

end
