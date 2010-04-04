# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Point do
  before(:each) do
    @point = Point.new(4326)
  end

  it "should instantiatember" do
    violated unless @point
    @point.should be_instance_of(Point)
  end

  it "should have a nice matcher" do
    @point.should be_a_point
  end

  it "should have a very nice matcher" do
    @point.should be_a_point(0.0, 0.0)
  end

  it "should have a very nice matcher" do
    Point.from_x_y_z_m(1,2,3.33,"t").should be_a_point(1, 2, 3.33, "t")
  end

  it "should have a dumb matcher" do
    Point.should be_geometric
  end

  it "should be subclassable" do
    place = Class.new(Point)
    p = place.from_x_y(1,2)
    p.should be_a place
  end

  it "should have binary_geometry_type 2" do
    @point.binary_geometry_type.should eql(1)
  end

  it "should have the correct srid" do
    @point.srid.should eql(4326)
  end

  it "should not have z or m" do
    @point.with_z.should be_false
    @point.should_not be_with_z
    @point.with_m.should be_false
    @point.should_not be_with_m
  end

  it "should set params to 0.0" do
    @point.x.should eql(0.0)
    @point.y.should eql(0.0)
    @point.z.should eql(0.0)
    @point.m.should eql(0.0)
  end

  it "should compare ok" do
    point1= Point::new
    point1.set_x_y(1.5,45.4)
    point2= Point::new
    point2.set_x_y(1.5,45.4)
    point3= Point::new
    point3.set_x_y(4.5,12.3)
    point4= Point::new
    point4.set_x_y_z(1.5,45.4,423)
    point5= Point::new
    point5.set_x_y(1.5,45.4)
    point5.m=15
    geometry= Geometry::new

    point1.should == point2
    point1.should_not == point3
    point1.should_not == point4
    point1.should_not == point5
    point1.should_not == geometry
  end

  describe "> Instantiation" do

    it "should instantiate a 2d point" do
      point = Point.from_x_y(10,20,123)
      point.x.should eql(10)
      point.y.should eql(20)
      point.srid.should eql(123)
      point.z.should eql(0.0)
    end

    it "should instantiate a 3d point" do
      point = Point.from_x_y_z(-10,-20,-30)
      point.x.should eql(-10)
      point.y.should eql(-20)
      point.z.should eql(-30)
    end

    it "should instantiate a 3d(m) point" do
      point = Point.from_x_y_m(10,20,30)
      point.x.should eql(10)
      point.y.should eql(20)
      point.m.should eql(30)
      point.z.should eql(0.0)
    end

    it "should instantiate a 4d point" do
      point = Point.from_x_y_z_m(10,20,30,40,123)
      point.x.should eql(10)
      point.y.should eql(20)
      point.z.should eql(30)
      point.m.should eql(40)
      point.srid.should eql(123)
    end

    it "should instantiate a point from polar coordinates" do
      point = Point.from_r_t(1.4142,45)
      point.y.should be_close(1, 0.00001)
      point.x.should be_close(1, 0.00001)
    end

    it "should instantiate from coordinates x,y" do
      point = Point.from_coordinates([1.6,2.8],123)
      point.x.should eql(1.6)
      point.y.should eql(2.8)
      point.should_not be_with_z
      point.z.should eql(0.0)
      point.srid.should eql(123)
    end

    it "should instantiate from coordinates x,y,z" do
      point = Point.from_coordinates([1.6,2.8,3.4],123, true)
      point.x.should eql(1.6)
      point.y.should eql(2.8)
      point.z.should eql(3.4)
      point.should be_with_z
      point.srid.should eql(123)
    end

    it "should instantiate from coordinates x,y,z,m" do
      point = Point.from_coordinates([1.6,2.8,3.4,15],123, true, true)
      point.x.should eql(1.6)
      point.y.should eql(2.8)
      point.z.should eql(3.4)
      point.m.should eql(15)
      point.should be_with_z
      point.should be_with_m
      point.srid.should eql(123)
    end

    it "should have a bbox" do
      bbox = Point.from_x_y_z_m(-1.6,2.8,-3.4,15,123).bounding_box
      bbox.length.should eql(2)
      bbox[0].should == Point.from_x_y_z(-1.6,2.8,-3.4)
      bbox[1].should == Point.from_x_y_z(-1.6,2.8,-3.4)
    end

    it "should parse lat long" do
      Point.from_latlong("-20° 47' 26.37","-20° 47' 26.37").x.should be_close(-20.790658, 0.00001)
      Point.from_latlong("20° 47' 26.378","20° 47' 26.378").y.should be_close(20.790658, 0.00001)
    end

    it "should parse lat long w/o sec" do
      Point.from_latlong("-20°47′26″","-20°47′26″").x.should be_close(-20.790555, 0.00001)
      Point.from_latlong("20°47′26″","20°47′26″").y.should be_close(20.790555, 0.00001)
    end

    it "should accept with W or S notation" do
      Point.from_latlong("20° 47' 26.37 W","20° 47' 26.37 S").x.should be_close(-20.790658, 0.00001)
      Point.from_latlong("20° 47' 26.37 W","20° 47' 26.37 S").y.should be_close(-20.790658, 0.00001)
    end

    it "should instantiate a point from positive degrees" do
      point = Point.from_latlong('47`20 06.09E','22`50 77.35N')
      point.y.should be_close(22.8548194, 0.000001)
      point.x.should be_close(47.335025, 0.000001)
    end

    it "should instantiate a point from negative degrees" do
      point = Point.from_latlong('47`20 06.09W','22`50 77.35S')
      point.y.should be_close(-22.8548194, 0.000001)
      point.x.should be_close(-47.335025, 0.000001)
    end

    it "should print out nicely" do
      Point.from_x_y(47.88, -20.1).as_latlong.should eql("47°52′48″, -20°06′00″")
    end

    it "should print out nicely" do
      Point.from_x_y(-20.78, 20.78).as_latlong(:full => true).should eql("-20°46′48.00″, 20°46′48.00″")
    end

    it "should print out nicely" do
      Point.from_x_y(47.11, -20.2).as_latlong(:full => true).should eql("47°06′36.00″, -20°11′60.00″")
    end

    it "should print out nicely" do
      Point.from_x_y(47.11, -20.2).as_latlong(:coord => true).should eql("47°06′36″N, 20°11′60″W")
    end

    it "should print out nicely" do
      Point.from_x_y(-47.11, 20.2).as_latlong(:full => true,:coord => true).should eql("47°06′36.00″S, 20°11′60.00″E")
    end

  end

  describe " > Distance & Bearing" do

    before(:each) do
      @p1 = Point.from_x_y(1,1)
      @p2 = Point.from_x_y(2,2)
    end

    it "and a 3th grade child should calculate euclidian distance" do
      @p1.euclidian_distance(@p2).
        should be_close(1.4142135623731, 0.00000001)
    end

    it "should calculate spherical distance" do
      @p1.spherical_distance(@p2).
        should be_close(157225.358003181,0.00000001)
    end

    it "should calculate ellipsoidal distance" do
      @p1.ellipsoidal_distance(@p2).
        should be_close(156876.149400742, 0.00000001)
    end

    describe "Orthogonal Distance" do
      before do
        @line = LineString.from_coordinates([[0,0],[1,3]], 4326)
        @line2 = LineString.from_coordinates([[1,1],[1,2]], 4326)
      end

      it "should calcula orthogonal distance from a line (90 deg)" do
        @p1.orthogonal_distance(@line).should be_close(1.414, 0.001)
      end

      it "should calcula orthogonal distance very close..." do
        @p1.orthogonal_distance(@line2).should be_zero
      end

      it "should calcula orthogonal distance from a line (90 deg)" do
        @p2.orthogonal_distance(@line).should be_close(2.828, 0.001)
      end

      it "should calcula orthogonal distance from a line (0 deg)" do
        @p2.orthogonal_distance(@line2).should be_close(1.0, 0.1)
      end

      it "should calcula orthogonal distance from a line (0 deg)" do
        @p2.orthogonal_distance(@line2).should be_close(1.0, 0.1)
      end

    end

    it "should calculate the bearing from apoint to another in degrees" do
      @p1.bearing_to(@p2).should be_close(45.0, 0.01)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      p3 = Point.from_x_y(1,-1)
      @p1.bearing_to(p3).should be_close(180.0, 0.01)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      p3 = Point.from_x_y(-1,-1)
      @p1.bearing_to(p3).should be_close(225.0, 0.01)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      p3 = Point.from_x_y(-1,1)
      @p1.bearing_to(p3).should be_close(270.0, 0.01)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      p3 = Point.from_x_y(2,-1)
      @p1.bearing_to(p3).should be_close(153.4349488, 0.0001)
    end

    it "should calculate a clone point bearing to 0" do
      @p1.bearing_to(@p1).should eql(0)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      @p1.bearing_text(@p2).should eql(:ne)
    end

    it "should calculate the bearing from apoint to another in degrees" do
      p3 = Point.from_x_y(-1,1)
      @p1.bearing_text(p3).should eql(:w)
    end

  end

  describe "> Export Formats" do

    before(:each) do
      @point = Point.from_x_y( -11.2431, 32.3141 )
    end

    it "should print nicely" do
      @point.text_representation.should eql("-11.2431 32.3141")
    end

    it "should printoout as binary" do
      Point.from_x_y(12.4,45.3,123).as_hex_ewkb.should eql("01010000207B000000CDCCCCCCCCCC28406666666666A64640")
      point = Point.from_x_y_z_m(12.4,45.3,-3.5,15,123)
      point.as_hex_ewkb.should eql("01010000E07B000000CDCCCCCCCCCC28406666666666A646400000000000000CC00000000000002E40")
      point.as_hex_wkb.should eql("0101000000CDCCCCCCCCCC28406666666666A64640")
    end

    it "should printoout as text" do
      Point.from_x_y(12.4,45.3,123).as_ewkt.should eql("SRID=123;POINT(12.4 45.3)")
      point = Point.from_x_y_z(12.4,45.3,-3.5,123)
      point.as_ewkt.should eql("SRID=123;POINT(12.4 45.3 -3.5)")
      point.as_wkt.should eql("POINT(12.4 45.3)")
      point.as_ewkt(false,true).should eql("POINT(12.4 45.3 -3.5)")
      point = Point.from_x_y_m(12.4,45.3,-3.5,123)
      point.as_ewkt.should eql("SRID=123;POINTM(12.4 45.3 -3.5)")
      point.as_ewkt(true,true,false).should eql("SRID=123;POINT(12.4 45.3)")
    end

    it "should have a nice bounding box" do
      @point.should have(2).bounding_box
      @point.bounding_box.each do |point|
        point.x.should eql(@point.x)
        point.y.should eql(@point.y)
      end
    end

    it "should print as kml too" do
      @point.kml_representation.should eql("<Point>\n<coordinates>-11.2431,32.3141</coordinates>\n</Point>\n")
    end

    it "should print as georss" do
      @point.georss_simple_representation(:georss_ns => 'hey').should eql("<hey:point>32.3141 -11.2431</hey:point>\n")
    end

    it "should print r (polar coords)" do
      @point.r.should be_close(34.214154, 0.00001)
    end

    it "should print theta as degrees" do
      @point.theta_deg.should be_close(289.184406352127, 0.0001)
    end

    it "should print theta as radians" do
      @point.theta_rad.should be_close(5.04722003626982, 0.0001)
    end

    it "should output as polar" do
      @point.as_polar.should be_instance_of(Array)
      @point.should have(2).as_polar #.length.should eql(2)
    end

  end

end
