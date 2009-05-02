require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MultiLineString do

 it "test_multi_line_string_creation" do
    multi_line_string1 = MultiLineString.from_line_strings([LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256),LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012],[45.123,123.3]],256)],256)
    multi_line_string1.should be_instance_of MultiLineString
    multi_line_string1.length.should eql(2)
    multi_line_string1[0].should == LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256)

    multi_line_string2= MultiLineString.from_coordinates([[[1.5,45.2],[-54.12312,-0.012]],[[1.5,45.2],[-54.12312,-0.012],[45.123,123.3]]],256);
    multi_line_string1.should be_instance_of MultiLineString
    multi_line_string1.length.should eql(2)
    multi_line_string2[0].should == LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256)

    multi_line_string2.should == multi_line_string2
  end

  it "test_multi_line_string_binary" do
    multi_line_string = MultiLineString.from_line_strings([LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256),LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012],[45.123,123.3]],256)],256)
    multi_line_string.as_hex_ewkb.should eql("01050000200001000002000000010200000002000000000000000000F83F9A99999999994640E4BD6A65C20F4BC0FA7E6ABC749388BF010200000003000000000000000000F83F9A99999999994640E4BD6A65C20F4BC0FA7E6ABC749388BF39B4C876BE8F46403333333333D35E40")

    multi_line_string = MultiLineString.from_line_strings([LineString.from_coordinates([[1.5,45.2,1.3,1.2],[-54.12312,-0.012,1.2,4.5]],256,true,true),LineString.from_coordinates([[1.5,45.2,5.1,-4.5],[-54.12312,-0.012,-6.8,3.4],[45.123,123.3,4.5,-5.3]],256,true,true)],256,true,true)
    multi_line_string.as_hex_ewkb.should eql("0105000020000100000200000001020000C002000000000000000000F83F9A99999999994640CDCCCCCCCCCCF43F333333333333F33FE4BD6A65C20F4BC0FA7E6ABC749388BF333333333333F33F000000000000124001020000C003000000000000000000F83F9A99999999994640666666666666144000000000000012C0E4BD6A65C20F4BC0FA7E6ABC749388BF3333333333331BC03333333333330B4039B4C876BE8F46403333333333D35E40000000000000124033333333333315C0")
  end

  it "test_multi_line_string_text" do
    multi_line_string = MultiLineString.from_line_strings([LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012]],256),LineString.from_coordinates([[1.5,45.2],[-54.12312,-0.012],[45.123,123.3]],256)],256)
    multi_line_string.as_ewkt.should eql("SRID=256;MULTILINESTRING((1.5 45.2,-54.12312 -0.012),(1.5 45.2,-54.12312 -0.012,45.123 123.3))")

    multi_line_string = MultiLineString.from_line_strings([LineString.from_coordinates([[1.5,45.2,1.3,1.2],[-54.12312,-0.012,1.2,4.5]],256,true,true),LineString.from_coordinates([[1.5,45.2,5.1,-4.5],[-54.12312,-0.012,-6.8,3.4],[45.123,123.3,4.5,-5.3]],256,true,true)],256,true,true)
    multi_line_string.as_ewkt.should eql("SRID=256;MULTILINESTRING((1.5 45.2 1.3 1.2,-54.12312 -0.012 1.2 4.5),(1.5 45.2 5.1 -4.5,-54.12312 -0.012 -6.8 3.4,45.123 123.3 4.5 -5.3))")
  end

end
