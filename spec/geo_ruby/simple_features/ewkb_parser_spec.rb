require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::EWKBParser do

  before(:each) do
    @factory = GeoRuby::SimpleFeatures::GeometryFactory::new
    @hex_ewkb_parser = GeoRuby::SimpleFeatures::HexEWKBParser::new(@factory)
  end

  it "test_point2d" do
    @hex_ewkb_parser.parse("01010000207B000000CDCCCCCCCCCC28406666666666A64640")
    point = @factory.geometry
    point.should be_instance_of GeoRuby::SimpleFeatures::Point
    point.should == GeoRuby::SimpleFeatures::Point.from_x_y(12.4,45.3,123)
  end

  it "test_point2d_BigEndian" do
    @hex_ewkb_parser.parse("00000000014013A035BD512EC7404A3060C38F3669")
    point = @factory.geometry
    point.should be_instance_of GeoRuby::SimpleFeatures::Point
    point.should == GeoRuby::SimpleFeatures::Point.from_x_y(4.906455,52.377953)
  end

  it "test_point3dz" do
    @hex_ewkb_parser.parse("01010000A07B000000CDCCCCCCCCCC28406666666666A646400000000000000CC0")
    point = @factory.geometry
    point.should be_instance_of GeoRuby::SimpleFeatures::Point
    point.should == GeoRuby::SimpleFeatures::Point.from_x_y_z(12.4,45.3,-3.5,123)
  end

  it "test_point4d" do
    @hex_ewkb_parser.parse("01010000E07B000000CDCCCCCCCCCC28406666666666A646400000000000000CC00000000000002E40")
    point = @factory.geometry
    point.should be_instance_of GeoRuby::SimpleFeatures::Point
    point.should == GeoRuby::SimpleFeatures::Point.from_x_y_z_m(12.4,45.3,-3.5,15,123)
  end

  it "test_line_string" do
    @hex_ewkb_parser.parse("01020000200001000002000000CDCCCCCCCCCC28406666666666A646C03333333333B34640CDCCCCCCCCCC4440")
    line_string = @factory.geometry
    line_string.should be_instance_of GeoRuby::SimpleFeatures::LineString
    line_string.should == GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4,-45.3],[45.4,41.6]],256)

    @hex_ewkb_parser.parse("01020000A00001000002000000CDCCCCCCCCCC28406666666666A646C06666666666A641403333333333B34640CDCCCCCCCCCC44409A99999999992840")
    line_string = @factory.geometry
    line_string.should be_instance_of GeoRuby::SimpleFeatures::LineString
    line_string.should == GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4,-45.3,35.3],[45.4,41.6,12.3]],256,true)

    @hex_ewkb_parser.parse("01020000E00001000002000000CDCCCCCCCCCC28406666666666A646C06666666666A64140CDCCCCCCCC8C46403333333333B34640CDCCCCCCCCCC44409A999999999928403D0AD7A3701D4440")
    line_string = @factory.geometry
    line_string.should be_instance_of GeoRuby::SimpleFeatures::LineString
    line_string.should == GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4,-45.3,35.3,45.1],[45.4,41.6,12.3,40.23]],256,true,true)
  end

  it "test_polygon" do
    @hex_ewkb_parser.parse("0103000020000100000200000005000000000000000000000000000000000000000000000000001040000000000000000000000000000010400000000000001040000000000000000000000000000010400000000000000000000000000000000005000000000000000000F03F000000000000F03F0000000000000840000000000000F03F00000000000008400000000000000840000000000000F03F0000000000000840000000000000F03F000000000000F03F")
    polygon = @factory.geometry
    polygon.should be_instance_of GeoRuby::SimpleFeatures::Polygon
    polygon.should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)

    @hex_ewkb_parser.parse("01030000A000010000020000000500000000000000000000000000000000000000000000000000004000000000000010400000000000000000000000000000004000000000000010400000000000001040000000000000004000000000000000000000000000001040000000000000004000000000000000000000000000000000000000000000004005000000000000000000F03F000000000000F03F00000000000000400000000000000840000000000000F03F0000000000000040000000000000084000000000000008400000000000000040000000000000F03F00000000000008400000000000000040000000000000F03F000000000000F03F0000000000000040")
    polygon = @factory.geometry
    polygon.should be_instance_of GeoRuby::SimpleFeatures::Polygon
    polygon.should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,true)

    @hex_ewkb_parser.parse("010300006000010000020000000500000000000000000000000000000000000000000000000000004000000000000010400000000000000000000000000000004000000000000010400000000000001040000000000000004000000000000000000000000000001040000000000000004000000000000000000000000000000000000000000000004005000000000000000000F03F000000000000F03F00000000000000400000000000000840000000000000F03F0000000000000040000000000000084000000000000008400000000000000040000000000000F03F00000000000008400000000000000040000000000000F03F000000000000F03F0000000000000040")
    polygon = @factory.geometry
    polygon.should be_instance_of GeoRuby::SimpleFeatures::Polygon
    polygon.should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256,false,true)

    @hex_ewkb_parser.parse("01030000E0000100000200000005000000000000000000000000000000000000000000000000000040CDCCCCCCCC8C46C00000000000001040000000000000000000000000000000400000000000001440000000000000104000000000000010400000000000000040AE47E17A14AE1240000000000000000000000000000010400000000000000040713D0AD7A370F53F000000000000000000000000000000000000000000000040CDCCCCCCCC8C46C005000000000000000000F03F000000000000F03F00000000000000409A999999999928400000000000000840000000000000F03F00000000000000400000000000C05E400000000000000840000000000000084000000000000000406666666666662840000000000000F03F000000000000084000000000000000400000000000002840000000000000F03F000000000000F03F00000000000000409A99999999992840")
    polygon = @factory.geometry
    polygon.should be_instance_of GeoRuby::SimpleFeatures::Polygon
    polygon.should == GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,2,-45.1],[4,0,2,5],[4,4,2,4.67],[0,4,2,1.34],[0,0,2,-45.1]],[[1,1,2,12.3],[3,1,2,123],[3,3,2,12.2],[1,3,2,12],[1,1,2,12.3]]],256,true,true)
  end

  it "test_geometry_collection" do
    @hex_ewkb_parser.parse("010700002000010000020000000101000000AE47E17A14AE12403333333333B34640010200000002000000CDCCCCCCCCCC16406666666666E628403333333333E350400000000000004B40")
    geometry_collection = @factory.geometry
    geometry_collection.should be_instance_of GeoRuby::SimpleFeatures::GeometryCollection

    geometry_collection.should == GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([GeoRuby::SimpleFeatures::Point.from_x_y(4.67,45.4,256),GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection[0].srid.should eql(256)

    @hex_ewkb_parser.parse("01070000E0000100000200000001010000C0AE47E17A14AE12403333333333B34640F6285C8FC2D54640666666666666024001020000C002000000CDCCCCCCCCCC16406666666666E628403D0AD7A3703D124033333333339358403333333333E350400000000000004B4066666666666628403333333333330B40")
    geometry_collection = @factory.geometry
    geometry_collection.should be_instance_of GeoRuby::SimpleFeatures::GeometryCollection
    geometry_collection.should == GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([GeoRuby::SimpleFeatures::Point.from_x_y_z_m(4.67,45.4,45.67,2.3,256),GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7,12.45,4.56,98.3],[67.55,54,12.2,3.4]],256,true, true)],256,true, true)
    geometry_collection[0].srid.should eql(256)
  end

  it "test_multi_point" do
    @hex_ewkb_parser.parse("0104000020BC010000030000000101000000CDCCCCCCCCCC28403333333333D35EC0010100000066666666664650C09A99999999D95E4001010000001F97DD388EE35E400000000000C05E40")
    multi_point = @factory.geometry
    multi_point.should be_instance_of GeoRuby::SimpleFeatures::MultiPoint
    multi_point.should == GeoRuby::SimpleFeatures::MultiPoint.from_coordinates([[12.4,-123.3],[-65.1,123.4],[123.55555555,123]],444)
    multi_point.srid.should eql(444)
    multi_point[0].srid.should eql(444)

    @hex_ewkb_parser.parse("01040000A0BC010000030000000101000080CDCCCCCCCCCC28403333333333D35EC00000000000001240010100008066666666664650C09A99999999D95E40333333333333F33F01010000801F97DD388EE35E400000000000C05E406666666666660240")
    multi_point = @factory.geometry
    multi_point.should be_instance_of GeoRuby::SimpleFeatures::MultiPoint
    multi_point.should == GeoRuby::SimpleFeatures::MultiPoint.from_coordinates([[12.4,-123.3,4.5],[-65.1,123.4,1.2],[123.55555555,123,2.3]],444,true)
    multi_point.srid.should eql(444)
    multi_point[0].srid.should eql(444)
  end

  it "test_multi_line_string" do
    @hex_ewkb_parser.parse("01050000200001000002000000010200000002000000000000000000F83F9A99999999994640E4BD6A65C20F4BC0FA7E6ABC749388BF010200000003000000000000000000F83F9A99999999994640E4BD6A65C20F4BC0FA7E6ABC749388BF39B4C876BE8F46403333333333D35E40")
    multi_line_string = @factory.geometry
    multi_line_string.should be_instance_of GeoRuby::SimpleFeatures::MultiLineString
    multi_line_string.should == GeoRuby::SimpleFeatures::MultiLineString.from_line_strings([GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256),GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012],[45.123,123.3]],256)],256)
    multi_line_string.srid.should eql(256)
    multi_line_string[0].srid.should eql(256)

    @hex_ewkb_parser.parse("0105000020000100000200000001020000C002000000000000000000F83F9A99999999994640CDCCCCCCCCCCF43F333333333333F33FE4BD6A65C20F4BC0FA7E6ABC749388BF333333333333F33F000000000000124001020000C003000000000000000000F83F9A99999999994640666666666666144000000000000012C0E4BD6A65C20F4BC0FA7E6ABC749388BF3333333333331BC03333333333330B4039B4C876BE8F46403333333333D35E40000000000000124033333333333315C0")
    multi_line_string = @factory.geometry
    multi_line_string.should be_instance_of GeoRuby::SimpleFeatures::MultiLineString
    multi_line_string.should == GeoRuby::SimpleFeatures::MultiLineString.from_line_strings([GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5,45.2,1.3,1.2],[-54.12312,-0.012,1.2,4.5]],256,true,true),GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5,45.2,5.1,-4.5],[-54.12312,-0.012,-6.8,3.4],[45.123,123.3,4.5,-5.3]],256,true,true)],256,true,true)
    multi_line_string.srid.should eql(256)
    multi_line_string[0].srid.should eql(256)
  end

  it "test_multi_polygon" do
    @hex_ewkb_parser.parse("0106000020000100000200000001030000000200000004000000CDCCCCCCCCCC28406666666666A646C03333333333B34640CDCCCCCCCCCC44406DE7FBA9F1D211403D2CD49AE61DF13FCDCCCCCCCCCC28406666666666A646C004000000333333333333034033333333333315409A999999999915408A8EE4F21FD2F63FEC51B81E85EB2C40F6285C8FC2F5F03F3333333333330340333333333333154001030000000200000005000000000000000000000000000000000000000000000000001040000000000000000000000000000010400000000000001040000000000000000000000000000010400000000000000000000000000000000005000000000000000000F03F000000000000F03F0000000000000840000000000000F03F00000000000008400000000000000840000000000000F03F0000000000000840000000000000F03F000000000000F03F")
    multi_polygon = @factory.geometry
    multi_polygon.should be_instance_of GeoRuby::SimpleFeatures::MultiPolygon
    multi_polygon.should == GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)],256)
    multi_polygon.srid.should eql(256)
    multi_polygon[0].srid.should eql(256)

    @hex_ewkb_parser.parse("0106000020000100000200000001030000400200000004000000CDCCCCCCCCCC28406666666666A646C0333333333333F33F3333333333B34640CDCCCCCCCCCC4440333333333333F33F6DE7FBA9F1D211403D2CD49AE61DF13F333333333333F33FCDCCCCCCCCCC28406666666666A646C0333333333333F33F0400000033333333333303403333333333331540333333333333F33F9A999999999915408A8EE4F21FD2F63F333333333333F33FEC51B81E85EB2C40F6285C8FC2F5F03F333333333333F33F33333333333303403333333333331540333333333333F33F0103000040020000000500000000000000000000000000000000000000333333333333F33F00000000000010400000000000000000333333333333F33F00000000000010400000000000001040666666666666024000000000000000000000000000001040333333333333F33F00000000000000000000000000000000333333333333F33F05000000000000000000F03F000000000000F03F9A999999999901400000000000000840000000000000F03F6666666666660A40000000000000084000000000000008409A9999999999F13F000000000000F03F00000000000008403333333333330340000000000000F03F000000000000F03F9A99999999990140")
    multi_polygon = @factory.geometry
    multi_polygon.should be_instance_of GeoRuby::SimpleFeatures::MultiPolygon
    multi_polygon.should == GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3,1.2],[45.4,41.6,1.2],[4.456,1.0698,1.2],[12.4,-45.3,1.2]],[[2.4,5.3,1.2],[5.4,1.4263,1.2],[14.46,1.06,1.2],[2.4,5.3,1.2]]],256,false,true),GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0,0,1.2],[4,0,1.2],[4,4,2.3],[0,4,1.2],[0,0,1.2]],[[1,1,2.2],[3,1,3.3],[3,3,1.1],[1,3,2.4],[1,1,2.2]]],256,false,true)],256,false,true)
    multi_polygon.srid.should eql(256)
    multi_polygon[0].srid.should eql(256)
  end


  it "test_failure_trailing_data" do
    #added A345 at the end
    lambda {@hex_ewkb_parser.parse("01010000207B000000CDCCCCCCCCCC28406666666666A64640A345")}.should raise_error(GeoRuby::SimpleFeatures::EWKBFormatError)
  end

  it "test_failure_unknown_geometry_type" do
    lambda {@hex_ewkb_parser.parse("01090000207B000000CDCCCCCCCCCC28406666666666A64640")}.should raise_error(GeoRuby::SimpleFeatures::EWKBFormatError)
  end

  it "test_failure_m" do
    lambda {@hex_ewkb_parser.parse("01010000607B000000CDCCCCCCCCCC28406666666666A64640")}.should raise_error(GeoRuby::SimpleFeatures::EWKBFormatError)
  end

  it "test_failure_truncated_data" do
    lambda {@hex_ewkb_parser.parse("01010000207B000000CDCCCCCCCCCC2840666666")}.should raise_error(GeoRuby::SimpleFeatures::EWKBFormatError)
  end

end
