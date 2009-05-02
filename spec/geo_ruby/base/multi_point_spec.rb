require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MultiPoint do

  it "test_multi_point_creation" do
    multi_point = MultiPoint.from_coordinates([[12.4,-123.3],[-65.1,123.4],[123.55555555,123]],444)
    multi_point.should be_instance_of MultiPoint
    multi_point.length.should eql(3)
    multi_point[0].should == Point.from_x_y(12.4,-123.3,444)
    multi_point[2].should == Point.from_x_y(123.55555555,123,444)
  end

  it "test_multi_point_binary" do
    multi_point = MultiPoint.from_coordinates([[12.4,-123.3],[-65.1,123.4],[123.55555555,123]],444)
    multi_point.as_hex_ewkb.should eql("0104000020BC010000030000000101000000CDCCCCCCCCCC28403333333333D35EC0010100000066666666664650C09A99999999D95E4001010000001F97DD388EE35E400000000000C05E40")

    multi_point = MultiPoint.from_coordinates([[12.4,-123.3,4.5],[-65.1,123.4,1.2],[123.55555555,123,2.3]],444,true)
    multi_point.as_hex_ewkb.should eql("01040000A0BC010000030000000101000080CDCCCCCCCCCC28403333333333D35EC00000000000001240010100008066666666664650C09A99999999D95E40333333333333F33F01010000801F97DD388EE35E400000000000C05E406666666666660240")
  end

  it "test_multi_point_text" do
    multi_point = MultiPoint.from_coordinates([[12.4,-123.3],[-65.1,123.4],[123.55555555,123]],444)
    multi_point.as_ewkt.should eql("SRID=444;MULTIPOINT((12.4 -123.3),(-65.1 123.4),(123.55555555 123))")

    multi_point = MultiPoint.from_coordinates([[12.4,-123.3,4.5],[-65.1,123.4,6.7],[123.55555555,123,7.8]],444,true)
    multi_point.as_ewkt.should eql("SRID=444;MULTIPOINT((12.4 -123.3 4.5),(-65.1 123.4 6.7),(123.55555555 123 7.8))")
  end

end
