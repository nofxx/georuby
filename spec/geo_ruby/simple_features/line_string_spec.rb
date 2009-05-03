require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module LineSpecHelper
  def mock_points(num)
#    @point = mock(Point, :x => 1.0, :y => 2.0)
    Array.new(num) { |i| mock_point(i,i) }
  end

  def mock_point(x=1,y=2)
    mock(Point, :x => x, :y => y, :text_representation => "#{x} #{y}")
  end
end

describe LineString do
  include LineSpecHelper

  before(:each) do
    @line = LineString.from_points([mock(Point)])
  end

  it "should instantiate" do
    violated unless @line
  end

  it "should have binary_geometry_type 2" do
    @line.binary_geometry_type.should eql(2)
  end

  it "should have text_geometry_type" do
    @line.text_geometry_type.should eql("LINESTRING")
  end

  it "should have a points array" do
    @line.points.should be_instance_of(Array)
  end

  describe "tu converted" do

    it "should concat points" do
      line_string = LineString::new
      line_string.concat([Point.from_x_y(12.4,45.3),Point.from_x_y(45.4,41.6)])

      line_string.length.should eql(2)
      line_string[0].should == Point.from_x_y(12.4,45.3)

      point=Point.from_x_y(123,45.8777)
      line_string[0]=point
      line_string[0].should == point

      points=[Point.from_x_y(123,45.8777),Point.from_x_y(45.4,41.6)]
      line_string.each_index {|i| line_string[i].should == points[i] }

      point=Point.from_x_y(22.4,13.56)
      line_string << point
      line_string.length.should eql(3)
      line_string[2].should eql(point)
    end

    it "should create" do
      line_string = LineString.from_points([Point.from_x_y(12.4,-45.3),Point.from_x_y(45.4,41.6)],123)
      line_string.class.should eql(LineString)
      line_string.length.should eql(2)
      line_string[0].should == Point.from_x_y(12.4,-45.3)
      line_string[1].should == Point.from_x_y(45.4,41.6)

      line_string = LineString.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698]],123)
      line_string.class.should eql(LineString)
      line_string.length.should eql(3)
      line_string[0].should == Point.from_x_y(12.4,-45.3)
      line_string[1].should == Point.from_x_y(45.4,41.6)

      line_string = LineString.from_coordinates([[12.4,-45.3,123],[45.4,41.6,333],[4.456,1.0698,987]],123,true)
      line_string.class.should eql(LineString)
      line_string.length.should eql(3)
      line_string[0].should == Point.from_x_y_z(12.4,-45.3,123,123)

      line_string = LineString.from_coordinates([[12.4,-45.3,123],[45.4,41.6,333],[4.456,1.0698,987]],123,true)
      line_string.class.should eql(LineString)
      line_string.length.should eql(3)
      line_string[0].should == Point.from_x_y_z(12.4,-45.3,123,123)
    end

    it "should bbox it" do
      bbox = LineString.from_coordinates([[12.4,-45.3,123],[45.4,41.6,333],[4.456,1.0698,987]],123,true).bounding_box
      bbox.length.should eql(2)
      bbox[0].should == Point.from_x_y_z(4.456,-45.3,123)
      bbox[1].should == Point.from_x_y_z(45.4,41.6,987)
    end

    it "should test_line_string_equal" do
      line_string1 = LineString.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698]],123)
      line_string2 = LineString.from_coordinates([[12.4,-45.3],[45.4,41.6]],123)
      point = Point.from_x_y(12.4,-45.3,123)

      line_string1.should == LineString.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698]],123)
      line_string1.should_not == line_string2
      line_string1.should_not == point
    end

    it "should test_line_string_binary" do
      line_string = LineString.from_coordinates([[12.4,-45.3],[45.4,41.6]],256)
      line_string.as_hex_ewkb.should eql("01020000200001000002000000CDCCCCCCCCCC28406666666666A646C03333333333B34640CDCCCCCCCCCC4440")

      line_string = LineString.from_coordinates([[12.4,-45.3,35.3],[45.4,41.6,12.3]],256,true)
      line_string.as_hex_ewkb.should eql("01020000A00001000002000000CDCCCCCCCCCC28406666666666A646C06666666666A641403333333333B34640CDCCCCCCCCCC44409A99999999992840")

      line_string = LineString.from_coordinates([[12.4,-45.3,35.3,45.1],[45.4,41.6,12.3,40.23]],256,true,true)
      line_string.as_hex_ewkb.should eql("01020000E00001000002000000CDCCCCCCCCCC28406666666666A646C06666666666A64140CDCCCCCCCC8C46403333333333B34640CDCCCCCCCCCC44409A999999999928403D0AD7A3701D4440")
    end

    it "test_line_string_text" do
      line_string = LineString.from_coordinates([[12.4,-45.3],[45.4,41.6]],256)
      line_string.as_ewkt.should eql("SRID=256;LINESTRING(12.4 -45.3,45.4 41.6)")

      line_string = LineString.from_coordinates([[12.4,-45.3,35.3],[45.4,41.6,12.3]],256,true)
      line_string.as_ewkt.should eql("SRID=256;LINESTRING(12.4 -45.3 35.3,45.4 41.6 12.3)")

      line_string = LineString.from_coordinates([[12.4,-45.3,35.3],[45.4,41.6,12.3]],256,false,true)
      line_string.as_ewkt.should eql("SRID=256;LINESTRINGM(12.4 -45.3 35.3,45.4 41.6 12.3)")

      line_string = LineString.from_coordinates([[12.4,-45.3,35.3,25.2],[45.4,41.6,12.3,13.75]],256,true,true)
      line_string.as_ewkt.should eql("SRID=256;LINESTRING(12.4 -45.3 35.3 25.2,45.4 41.6 12.3 13.75)")
    end

    it "should test_linear_ring_creation" do
      #testing just the constructor helpers since the rest is the same as for line_string
      linear_ring = LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],345)
      linear_ring.class.should eql(LinearRing)
      linear_ring.length.should eql(4)
      linear_ring.should be_closed
      linear_ring[1].should == Point.from_x_y(45.4,41.6,345)
    end
  end

  describe "> Coordinates" do

    before(:each) do
      Point.should_receive(:from_coordinates).
        exactly(4).with(anything, 4326, false, false).and_return(mock_point)
      @line = LineString.from_coordinates([1.2,2.5,2.2,4.5])
    end

    it "should instantiate from coordinates" do
      @line.points.length.should eql(4)
    end

  end

  describe "> Instantiated" do

    before(:each) do
      @line = LineString.from_points(mock_points(7))
    end

    it "should be closed if the last point equals the first" do
      @line.push(@line.first)
      @line.should be_closed
      @line.length.should eql(8)
    end

    it "should print the text representation" do
      @line.text_representation.should eql("0 0,1 1,2 2,3 3,4 4,5 5,6 6")
    end

    it "should print the georss_simple_representation" do
      @line.georss_simple_representation({:geom_attr => nil}).
        should eql("<georss:line>0 0 1 1 2 2 3 3 4 4 5 5 6 6</georss:line>\n")
    end

    it "should map the georss_poslist" do
      @line.georss_poslist.should eql("0 0 1 1 2 2 3 3 4 4 5 5 6 6")
    end

    it "should print the kml_representation" do
      @line.kml_representation.should
        eql("<LineString>\n<coordinates>0,0 1,1 2,2 3,3 4,4 5,5 6,6</coordinates>\n</LineString>\n")
    end

    it "should print the kml_poslist without reverse or z" do
      @line.kml_poslist({}).should eql("0,0 1,1 2,2 3,3 4,4 5,5 6,6")
    end

    it "should print the kml_poslist reverse" do
      @line.kml_poslist({:reverse => true}).should eql("6,6 5,5 4,4 3,3 2,2 1,1 0,0")
    end
  end

  describe "> Distances..." do
    before(:each) do
      @p1 = mock(Point)
      @p2 = mock(Point)
      @p3 = mock(Point)
      @line = LineString.from_points([@p1,@p2,@p3])
    end

    it "should print the length with haversine" do
      @p1.should_receive(:spherical_distance).with(@p2).and_return(10)
      @p2.should_receive(:spherical_distance).with(@p3).and_return(10)
      @line.spherical_distance.should eql(20)
    end

    it "should print lenght as euclidian" do
      @p1.should_receive(:euclidian_distance).with(@p2).and_return(10)
      @p2.should_receive(:euclidian_distance).with(@p3).and_return(10)
      @line.euclidian_distance.should eql(20)
    end
  end
end
