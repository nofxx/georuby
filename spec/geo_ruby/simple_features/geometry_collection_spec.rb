require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeometryCollection do

  it "should test_geometry_collection_creation" do
    geometry_collection = GeometryCollection::new(256)
    geometry_collection << Point.from_x_y(4.67,45.4,256)

    geometry_collection.length.should eql(1)
    geometry_collection[0].should == Point.from_x_y(4.67,45.4,256)

    geometry_collection[0]=LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)
    geometry_collection << Polygon.from_coordinates([[[0,0],[4,0],[4,4],[0,4],[0,0]],[[1,1],[3,1],[3,3],[1,3],[1,1]]],256)
    geometry_collection.length.should eql(2)
    geometry_collection[0].should == LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)

    geometry_collection = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection.class.should eql(GeometryCollection)
    geometry_collection.srid.should eql(256)
    geometry_collection.length.should eql(2)
    geometry_collection[1].should == LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)

    bbox = geometry_collection.bounding_box
    bbox.length.should eql(2)
    bbox[0].should == Point.from_x_y(4.67,12.45)
    bbox[1].should == Point.from_x_y(67.55,54)
  end

  it "test_geometry_collection_equal" do
    geometry_collection1 = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection2 = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256),Polygon.from_coordinates([[[0,0,2],[4,0,2],[4,4,2],[0,4,2],[0,0,2]],[[1,1,2],[3,1,2],[3,3,2],[1,3,2],[1,1,2]]],256)],256,true)
    line_string=LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)

    geometry_collection1.should == GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection2.should_not == geometry_collection1
    line_string.should_not == geometry_collection1
  end

  it "test_geometry_collection_binary" do
    geometry_collection = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection.as_hex_ewkb.should eql("010700002000010000020000000101000000AE47E17A14AE12403333333333B34640010200000002000000CDCCCCCCCCCC16406666666666E628403333333333E350400000000000004B40")

    geometry_collection = GeometryCollection.from_geometries([Point.from_x_y_z_m(4.67,45.4,45.67,2.3,256),LineString.from_coordinates([[5.7,12.45,4.56,98.3],[67.55,54,12.2,3.4]],256,true, true)],256,true, true)
    geometry_collection.as_hex_ewkb.should eql("01070000E0000100000200000001010000C0AE47E17A14AE12403333333333B34640F6285C8FC2D54640666666666666024001020000C002000000CDCCCCCCCCCC16406666666666E628403D0AD7A3703D124033333333339358403333333333E350400000000000004B4066666666666628403333333333330B40")
  end

  it "should test_geometry_collection_text" do
    geometry_collection = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)
    geometry_collection.as_ewkt.should eql("SRID=256;GEOMETRYCOLLECTION(POINT(4.67 45.4),LINESTRING(5.7 12.45,67.55 54))")

    geometry_collection = GeometryCollection.from_geometries([Point.from_x_y_m(4.67,45.4,45.6,256),LineString.from_coordinates([[5.7,12.45,5.6],[67.55,54,6.7]],256,false,true)],256,false,true)
    geometry_collection.as_ewkt.should eql("SRID=256;GEOMETRYCOLLECTIONM(POINTM(4.67 45.4 45.6),LINESTRINGM(5.7 12.45 5.6,67.55 54 6.7))")
  end

end
