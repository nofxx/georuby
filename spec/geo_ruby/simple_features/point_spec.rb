# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::Point do
  let(:point) { GeoRuby::SimpleFeatures::Point.new(4326) }

  it 'should instantiatember' do
    violated unless point
    expect(point).to be_instance_of(GeoRuby::SimpleFeatures::Point)
  end

  it 'should have a nice matcher' do
    expect(point).to be_a_point
  end

  it 'should have a text geometry type' do
    expect(point.text_geometry_type).to eq('POINT')
  end

  it 'should have a very nice matcher' do
    expect(point).to be_a_point(0.0, 0.0)
  end

  it 'should have a very nice matcher' do
    expect(GeoRuby::SimpleFeatures::Point.from_x_y_z_m(1, 2, 3.33, 't'))
      .to be_a_point(1, 2, 3.33, 't')
  end

  it 'should have a dumb matcher' do
    expect(GeoRuby::SimpleFeatures::Point).to be_geometric
  end

  it 'should be subclassable' do
    place = Class.new(GeoRuby::SimpleFeatures::Point)
    p = place.from_x_y(1, 2)
    expect(p).to be_a place
  end

  it 'should have binary_geometry_type 2' do
    expect(point.binary_geometry_type).to eql(1)
  end

  it 'should have the correct srid' do
    expect(point.srid).to eql(4326)
  end

  it 'should not have z or m' do
    expect(point.with_z).to be_falsey
    expect(point).not_to be_with_z
    expect(point.with_m).to be_falsey
    expect(point).not_to be_with_m
  end

  it 'should set params to 0.0' do
    expect(point.x).to eql(0.0)
    expect(point.y).to eql(0.0)
    expect(point.z).to eql(0.0)
    expect(point.m).to eql(0.0)
  end

  it 'should compare ok' do
    point1 = GeoRuby::SimpleFeatures::Point.new
    point1.set_x_y(1.5, 45.4)
    point2 = GeoRuby::SimpleFeatures::Point.new
    point2.set_x_y(1.5, 45.4)
    point3 = GeoRuby::SimpleFeatures::Point.new
    point3.set_x_y(4.5, 12.3)
    point4 = GeoRuby::SimpleFeatures::Point.new
    point4.set_x_y_z(1.5, 45.4, 423)
    point5 = GeoRuby::SimpleFeatures::Point.new
    point5.set_x_y(1.5, 45.4)
    point5.m = 15
    geometry = GeoRuby::SimpleFeatures::Geometry.new

    expect(point1).to eq(point2)
    expect(point1).not_to eq(point3)
    expect(point1).not_to eq(point4)
    expect(point1).not_to eq(point5)
    expect(point1).not_to eq(geometry)
  end

  describe '> Instantiation' do

    it 'should instantiate a 2d point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y(10, 20, 123)
      expect(point.x).to eql(10)
      expect(point.y).to eql(20)
      expect(point.srid).to eql(123)
      expect(point.z).to eql(0.0)
    end

    it 'should instantiate a 2d easily' do
      point = GeoRuby::SimpleFeatures::Point.xy(10, 20, 123)
      expect(point.x).to eql(10)
      expect(point.y).to eql(20)
      expect(point.srid).to eql(123)
    end

    it 'should instantiate a 3d point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z(-10, -20, -30)
      expect(point.x).to eql(-10)
      expect(point.y).to eql(-20)
      expect(point.z).to eql(-30)
    end

    it 'should store correctly a 3d point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z(-10, -20, -30)
      expect(point.to_coordinates).to eq([-10, -20, -30])
    end

    it 'should instantiate a 3d(m) point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y_m(10, 20, 30)
      expect(point.x).to eql(10)
      expect(point.y).to eql(20)
      expect(point.m).to eql(30)
      expect(point.z).to eql(0.0)
    end

    it 'should instantiate a 4d point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z_m(10, 20, 30, 40, 123)
      expect(point.x).to eql(10)
      expect(point.y).to eql(20)
      expect(point.z).to eql(30)
      expect(point.m).to eql(40)
      expect(point.srid).to eql(123)
    end

    it 'should store correctly a 4d point' do
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z_m(-10, -20, -30, 1)
      expect(point.m).to eql(1)
      expect(point.to_coordinates).to eq([-10, -20, -30, 1])
    end

    it 'should instantiate a point from polar coordinates' do
      point = GeoRuby::SimpleFeatures::Point.from_r_t(1.4142, 45)
      expect(point.y).to be_within(0.1).of(1)
      expect(point.x).to be_within(0.1).of(1)
    end

    it 'should instantiate from coordinates x,y' do
      point = GeoRuby::SimpleFeatures::Point.from_coordinates([1.6, 2.8], 123)
      expect(point.x).to eql(1.6)
      expect(point.y).to eql(2.8)
      expect(point).not_to be_with_z
      expect(point.z).to eql(0.0)
      expect(point.srid).to eql(123)
    end

    it 'should instantiate from coordinates x,y,z' do
      point = GeoRuby::SimpleFeatures::Point.from_coordinates([1.6, 2.8, 3.4], 123, true)
      expect(point.x).to eql(1.6)
      expect(point.y).to eql(2.8)
      expect(point.z).to eql(3.4)
      expect(point).to be_with_z
      expect(point.srid).to eql(123)
    end

    it 'should instantiate from coordinates x,y,z,m' do
      point = GeoRuby::SimpleFeatures::Point.from_coordinates([1.6, 2.8, 3.4, 15], 123, true, true)
      expect(point.x).to eql(1.6)
      expect(point.y).to eql(2.8)
      expect(point.z).to eql(3.4)
      expect(point.m).to eql(15)
      expect(point).to be_with_z
      expect(point).to be_with_m
      expect(point.srid).to eql(123)
    end

    it 'should have a bbox' do
      bbox = GeoRuby::SimpleFeatures::Point.from_x_y_z_m(-1.6, 2.8, -3.4, 15, 123).bounding_box
      expect(bbox.length).to eql(2)
      expect(bbox[0]).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_z(-1.6, 2.8, -3.4))
      expect(bbox[1]).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_z(-1.6, 2.8, -3.4))
    end

    it 'should parse lat long' do
      expect(GeoRuby::SimpleFeatures::Point.from_latlong("-20° 47' 26.37", "-20° 47' 26.37").x).to be_within(0.00001).of(-20.790658)
      expect(GeoRuby::SimpleFeatures::Point.from_latlong("20° 47' 26.378", "20° 47' 26.378").y).to be_within(0.00001).of(20.790658)
    end

    it 'should parse lat long w/o sec' do
      expect(GeoRuby::SimpleFeatures::Point.from_latlong('-20°47′26″', '-20°47′26″').x).to be_within(0.00001).of(-20.790555)
      expect(GeoRuby::SimpleFeatures::Point.from_latlong('20°47′26″', '20°47′26″').y).to be_within(0.00001).of(20.790555)
    end

    it 'should accept with W or S notation' do
      expect(GeoRuby::SimpleFeatures::Point.from_latlong("20° 47' 26.37 W", "20° 47' 26.37 S").x).to be_within(0.00001).of(-20.790658)
      expect(GeoRuby::SimpleFeatures::Point.from_latlong("20° 47' 26.37 W", "20° 47' 26.37 S").y).to be_within(0.00001).of(-20.790658)
    end

    it 'should instantiate a point from positive degrees' do
      point = GeoRuby::SimpleFeatures::Point.from_latlong('47`20 06.09E', '22`50 77.35N')
      expect(point.y).to be_within(0.000001).of(22.8548194)
      expect(point.x).to be_within(0.000001).of(47.335025)
    end

    it 'should instantiate a point from negative degrees' do
      point = GeoRuby::SimpleFeatures::Point.from_latlong('47`20 06.09W', '22`50 77.35S')
      expect(point.y).to be_within(0.000001).of(-22.8548194)
      expect(point.x).to be_within(0.000001).of(-47.335025)
    end

    it 'should print out nicely' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(47.88, -20.1).as_latlong).to eql('47°52′48″, -20°06′00″')
    end

    it 'should print out nicely latlong' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-20.78, 20.78).as_latlong(full: true)).to eql('-20°46′48.00″, 20°46′48.00″')
    end

    it 'should print out nicely latlong' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(47.11, -20.2).as_latlong(full: true)).to eql('47°06′36.00″, -20°11′60.00″')
    end

    it 'should print out nicely latlong' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(47.11, -20.2).as_latlong(coord: true)).to eql('47°06′36″N, 20°11′60″W')
    end

    it 'should print out nicely latlong' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_latlong(full: true, coord: true)).to eql('47°06′36.00″S, 20°11′60.00″E')
    end

    it 'should print out nicely lat' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_lat).to eql('-47°06′36″')
    end

    it 'should print out nicely lat with opts' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_lat(full: true)).to eql('-47°06′36.00″')
    end

    it 'should print out nicely lat with opts' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_lat(full: true, coord: true)).to eql('47°06′36.00″S')
    end

    it 'should print out nicely long' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_long).to eql('20°11′60″')
    end

    it 'should print out nicely long with opts' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_long(full: true)).to eql('20°11′60.00″')
    end

    it 'should print out nicely long with opts' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_long(full: true, coord: true)).to eql('20°11′60.00″E')
    end

  end

  describe ' > Distance & Bearing' do

    let(:p1) { GeoRuby::SimpleFeatures::Point.from_x_y(1, 1) }
    let(:p2) { GeoRuby::SimpleFeatures::Point.from_x_y(2, 2) }

    it 'and a 3th grade child should calculate euclidian distance' do
      expect(p1.euclidian_distance(p2))
        .to be_within(0.00000001).of(1.4142135623731)
    end

    it 'should calculate spherical distance' do
      expect(p1.spherical_distance(p2))
        .to be_within(0.00000001).of(157_225.358003181)
    end

    it 'should calculate ellipsoidal distance' do
      expect(p1.ellipsoidal_distance(p2))
        .to be_within(0.00000001).of(156_876.149400742)
    end

    describe 'Orthogonal Distance' do

      let(:line) { GeoRuby::SimpleFeatures::LineString.from_coordinates([[0, 0], [1, 3]], 4326) }
      let(:line2) { GeoRuby::SimpleFeatures::LineString.from_coordinates([[1, 1], [1, 2]], 4326) }

      it 'should calcula orthogonal distance from a line (90 deg)' do
        expect(p1.orthogonal_distance(line)).to be_within(0.001).of(1.414)
      end

      it 'should calcula orthogonal distance very close...' do
        expect(p1.orthogonal_distance(line2)).to be_zero
      end

      it 'should calcula orthogonal distance from a line (90 deg)' do
        expect(p2.orthogonal_distance(line)).to be_within(0.001).of(2.828)
      end

      it 'should calcula orthogonal distance from a line (0 deg)' do
        expect(p2.orthogonal_distance(line2)).to be_within(0.1).of(1.0)
      end

      it 'should calcula orthogonal distance from a line (0 deg)' do
        expect(p2.orthogonal_distance(line2)).to be_within(0.1).of(1.0)
      end

    end

    describe 'Bearing' do

      it 'should calculate the bearing from apoint to another in degrees' do
        expect(p1.bearing_to(p2)).to be_within(0.01).of(45.0)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        p3 = GeoRuby::SimpleFeatures::Point.from_x_y(1, -1)
        expect(p1.bearing_to(p3)).to be_within(0.01).of(180.0)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        p3 = GeoRuby::SimpleFeatures::Point.from_x_y(-1, -1)
        expect(p1.bearing_to(p3)).to be_within(0.01).of(225.0)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        p3 = GeoRuby::SimpleFeatures::Point.from_x_y(-1, 1)
        expect(p1.bearing_to(p3)).to be_within(0.01).of(270.0)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        p3 = GeoRuby::SimpleFeatures::Point.from_x_y(2, -1)
        expect(p1.bearing_to(p3)).to be_within(0.0001).of(153.4349488)
      end

      it 'should calculate a clone point bearing to 0' do
        expect(p1.bearing_to(p1)).to eql(0)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        expect(p1.bearing_text(p2)).to eql(:ne)
      end

      it 'should calculate the bearing from apoint to another in degrees' do
        p3 = GeoRuby::SimpleFeatures::Point.from_x_y(-1, 1)
        expect(p1.bearing_text(p3)).to eql(:w)
      end

    end

  end

  describe '> Export Formats' do

    let(:point) { GeoRuby::SimpleFeatures::Point.from_x_y(-11.2431, 32.3141) }

    it 'should print out as array' do

    end

    it 'should print nicely' do
      expect(point.text_representation).to eql('-11.2431 32.3141')
    end

    it 'should printoout as binary' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(12.4, 45.3, 123).as_hex_ewkb).to eql('01010000207B000000CDCCCCCCCCCC28406666666666A64640')
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z_m(12.4, 45.3, -3.5, 15, 123)
      expect(point.as_hex_ewkb).to eql('01010000E07B000000CDCCCCCCCCCC28406666666666A646400000000000000CC00000000000002E40')
      expect(point.as_hex_wkb).to eql('0101000000CDCCCCCCCCCC28406666666666A64640')
    end

    it 'should printoout as text' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(12.4, 45.3, 123).as_ewkt).to eql('SRID=123;POINT(12.4 45.3)')
      point = GeoRuby::SimpleFeatures::Point.from_x_y_z(12.4, 45.3, -3.5, 123)
      expect(point.as_ewkt).to eql('SRID=123;POINT(12.4 45.3 -3.5)')
      expect(point.as_wkt).to eql('POINT(12.4 45.3)')
      expect(point.as_ewkt(false, true)).to eql('POINT(12.4 45.3 -3.5)')
      point = GeoRuby::SimpleFeatures::Point.from_x_y_m(12.4, 45.3, -3.5, 123)
      expect(point.as_ewkt).to eql('SRID=123;POINTM(12.4 45.3 -3.5)')
      expect(point.as_ewkt(true, true, false)).to eql('SRID=123;POINT(12.4 45.3)')
    end

    it 'should have a nice bounding box' do
      expect(point.bounding_box.size).to eq(2)
      point.bounding_box.each do |point|
        expect(point.x).to eql(point.x)
        expect(point.y).to eql(point.y)
      end
    end

    it 'should print as kml too' do
      expect(point.kml_representation).to eql("<Point>\n<coordinates>-11.2431,32.3141</coordinates>\n</Point>\n")
    end

    it 'should print as html too' do
      expect(point.html_representation).to eql("<span class='geo'><abbr class='latitude' title='-11.2431'>11°14′35″S</abbr><abbr class='longitude' title='32.3141'>32°18′51″E</abbr></span>")
    end

    it 'should print as html too with opts' do
      expect(point.html_representation(coord: false)).to eql("<span class='geo'><abbr class='latitude' title='-11.2431'>-11°14′35″</abbr><abbr class='longitude' title='32.3141'>32°18′51″</abbr></span>")
    end

    it 'should print as html too with opts' do
      expect(point.html_representation(full: true)).to eql("<span class='geo'><abbr class='latitude' title='-11.2431'>11°14′35.16″S</abbr><abbr class='longitude' title='32.3141'>32°18′50.76″E</abbr></span>")
    end

    it 'should print as georss' do
      expect(point.georss_simple_representation(georss_ns: 'hey')).to eql("<hey:point>32.3141 -11.2431</hey:point>\n")
    end

    it 'should print r (polar coords)' do
      expect(point.r).to be_within(0.000001).of(34.214154)
    end

    it 'should print theta as degrees' do
      expect(point.theta_deg).to be_within(0.0001).of(289.184406352127)
    end

    it 'should print theta as radians' do
      expect(point.theta_rad).to be_within(0.0001).of(5.04722003626982)
    end

    it 'should print theta when x is zero y > 0' do
      pt = GeoRuby::SimpleFeatures::Point.from_x_y(0.0, 32.3141)
      expect(pt.theta_rad).to be_within(0.0001).of(1.5707963267948966)
    end

    it 'should print theta when x is zero y < 0' do
      pt = GeoRuby::SimpleFeatures::Point.from_x_y(0.0, -32.3141)
      expect(pt.theta_rad).to be_within(0.0001).of(4.71238898038469)
    end

    it 'should output as polar' do
      expect(point.as_polar).to be_instance_of(Array)
      expect(point.as_polar.size).to eq(2) # .length.should eql(2)
    end

    it 'should print out nicely as json/geojson' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).as_json).to eql(type: 'Point', coordinates: [-47.11, 20.2])
    end

    it 'should print out nicely to json/geojson' do
      expect(GeoRuby::SimpleFeatures::Point.from_x_y(-47.11, 20.2).to_json).to eql("{\"type\":\"Point\",\"coordinates\":[-47.11,20.2]}")
    end

  end

end
