require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::EWKTParser do

  before(:each) do
    @factory = GeoRuby::SimpleFeatures::GeometryFactory.new
    @ewkt_parser = GeoRuby::SimpleFeatures::EWKTParser.new(@factory)
  end

  it 'test_point' do
    ewkt = 'POINT( 3.456 0.123)'
    @ewkt_parser.parse(ewkt)
    point = @factory.geometry
    expect(point).to be_instance_of GeoRuby::SimpleFeatures::Point
    expect(point).to eq(GeoRuby::SimpleFeatures::Point.from_x_y(3.456, 0.123))
  end

  it 'test_point_with_srid' do
    ewkt = 'SRID=245;POINT(0.0 2.0)'
    @ewkt_parser.parse(ewkt)
    point = @factory.geometry
    expect(point).to be_instance_of GeoRuby::SimpleFeatures::Point
    expect(point).to eq(GeoRuby::SimpleFeatures::Point.from_x_y(0, 2, 245))
    expect(point.srid).to eql(245)
    expect(ewkt).to eq(point.as_ewkt(true, false))
  end

  it 'test_point3dz' do
    ewkt = 'POINT(3.456 0.123 123.667)'
    @ewkt_parser.parse(ewkt)
    point = @factory.geometry
    expect(point).to be_instance_of GeoRuby::SimpleFeatures::Point
    expect(point).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_z(3.456, 0.123, 123.667))
    expect(ewkt).to eq(point.as_ewkt(false))
  end

  it 'test_point3dm' do
    ewkt = 'POINTM(3.456 0.123 123.667)'
    @ewkt_parser.parse(ewkt)
    point = @factory.geometry
    expect(point).to be_instance_of GeoRuby::SimpleFeatures::Point
    expect(point).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_m(3.456, 0.123, 123.667))
    expect(ewkt).to eq(point.as_ewkt(false))
  end

  it 'test_point4d' do
    ewkt = 'POINT(3.456 0.123 123.667 15.0)'
    @ewkt_parser.parse(ewkt)
    point = @factory.geometry
    expect(point).to be_instance_of GeoRuby::SimpleFeatures::Point
    expect(point).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_z_m(3.456, 0.123, 123.667, 15.0))
    expect(ewkt).to eq(point.as_ewkt(false))
  end

  it 'test_linestring' do
    @ewkt_parser.parse('LINESTRING(3.456 0.123,123.44 123.56,54555.22 123.3)')
    line_string = @factory.geometry
    expect(line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
    expect(line_string).to eq(GeoRuby::SimpleFeatures::LineString.from_coordinates([[3.456, 0.123], [123.44, 123.56], [54_555.22, 123.3]]))

    @ewkt_parser.parse('SRID=256;LINESTRING(12.4 -45.3,45.4 41.6)')
    line_string = @factory.geometry
    expect(line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
    expect(line_string).to eq(GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4, -45.3], [45.4, 41.6]], 256))

    @ewkt_parser.parse('SRID=256;LINESTRING(12.4 -45.3 35.3,45.4 41.6 12.3)')
    line_string = @factory.geometry
    expect(line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
    expect(line_string).to eq(GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4, -45.3, 35.3], [45.4, 41.6, 12.3]], 256, true))

    @ewkt_parser.parse('SRID=256;LINESTRINGM(12.4 -45.3 35.3,45.4 41.6 12.3)')
    line_string = @factory.geometry
    expect(line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
    expect(line_string).to eq(GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4, -45.3, 35.3], [45.4, 41.6, 12.3]], 256, false, true))

    @ewkt_parser.parse('SRID=256;LINESTRING(12.4 -45.3 35.3 25.2,45.4 41.6 12.3 13.75)')
    line_string = @factory.geometry
    expect(line_string).to be_instance_of GeoRuby::SimpleFeatures::LineString
    expect(line_string).to eq(GeoRuby::SimpleFeatures::LineString.from_coordinates([[12.4, -45.3, 35.3, 25.2], [45.4, 41.6, 12.3, 13.75]], 256, true, true))
  end

  it 'test_polygon' do
    @ewkt_parser.parse('POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1,3 1,3 3,1 3,1 1))')
    polygon = @factory.geometry
    expect(polygon).to be_instance_of GeoRuby::SimpleFeatures::Polygon
    expect(polygon).to eq(GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0], [4, 0], [4, 4], [0, 4], [0, 0]], [[1, 1], [3, 1], [3, 3], [1, 3], [1, 1]]], 256))

    @ewkt_parser.parse('SRID=256;POLYGON( ( 0 0  2,4 0 2,4 4 2,0 4 2,0 0 2),(1 1 2,3 1 2,3 3 2,1 3 2,1 1 2))')
    polygon = @factory.geometry
    expect(polygon).to be_instance_of GeoRuby::SimpleFeatures::Polygon
    expect(polygon).to eq(GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0, 2], [4, 0, 2], [4, 4, 2], [0, 4, 2], [0, 0, 2]], [[1, 1, 2], [3, 1, 2], [3, 3, 2], [1, 3, 2], [1, 1, 2]]], 256, true))

    @ewkt_parser.parse('SRID=256;POLYGONM((0 0 2,4 0 2,4 4 2,0 4 2,0 0 2),(1 1 2,3 1 2,3 3 2,1 3 2,1 1 2))')
    polygon = @factory.geometry
    expect(polygon).to be_instance_of GeoRuby::SimpleFeatures::Polygon
    expect(polygon).to eq(GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0, 2], [4, 0, 2], [4, 4, 2], [0, 4, 2], [0, 0, 2]], [[1, 1, 2], [3, 1, 2], [3, 3, 2], [1, 3, 2], [1, 1, 2]]], 256, false, true))

    @ewkt_parser.parse('SRID=256;POLYGON((0 0 2 -45.1,4 0 2 5,4 4 2 4.67,0 4 2 1.34,0 0 2 -45.1),(1 1 2 12.3,3 1 2 123,3 3 2 12.2,1 3 2 12,1 1 2 12.3))')
    polygon = @factory.geometry
    expect(polygon).to be_instance_of GeoRuby::SimpleFeatures::Polygon
    expect(polygon).to eq(GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0, 2, -45.1], [4, 0, 2, 5], [4, 4, 2, 4.67], [0, 4, 2, 1.34], [0, 0, 2, -45.1]], [[1, 1, 2, 12.3], [3, 1, 2, 123], [3, 3, 2, 12.2], [1, 3, 2, 12], [1, 1, 2, 12.3]]], 256, true, true))
  end

  it 'test_multi_point' do
    # Form output by the current version of PostGIS. Future versions will output the one in the specification
    @ewkt_parser.parse('SRID=444;MULTIPOINT(12.4 -123.3,-65.1 123.4,123.55555555 123)')
    multi_point = @factory.geometry
    expect(multi_point).to be_instance_of GeoRuby::SimpleFeatures::MultiPoint
    expect(multi_point).to eq(GeoRuby::SimpleFeatures::MultiPoint.from_coordinates([[12.4, -123.3], [-65.1, 123.4], [123.55555555, 123]], 444))
    expect(multi_point.srid).to eql(444)
    expect(multi_point[0].srid).to eql(444)

    @ewkt_parser.parse('SRID=444;MULTIPOINT(12.4 -123.3 4.5,-65.1 123.4 6.7,123.55555555 123 7.8)')
    multi_point = @factory.geometry
    expect(multi_point).to be_instance_of GeoRuby::SimpleFeatures::MultiPoint
    expect(multi_point).to eq(GeoRuby::SimpleFeatures::MultiPoint.from_coordinates([[12.4, -123.3, 4.5], [-65.1, 123.4, 6.7], [123.55555555, 123, 7.8]], 444, true))
    expect(multi_point.srid).to eql(444)
    expect(multi_point[0].srid).to eql(444)

    # Form in the EWKT specification (from the OGC)
    @ewkt_parser.parse('SRID=444;MULTIPOINT( ( 12.4   -123.3 4.5 ) , (-65.1 123.4 6.7),(123.55555555 123 7.8))')
    multi_point = @factory.geometry
    expect(multi_point).to be_instance_of GeoRuby::SimpleFeatures::MultiPoint
    expect(multi_point).to eq(GeoRuby::SimpleFeatures::MultiPoint.from_coordinates([[12.4, -123.3, 4.5], [-65.1, 123.4, 6.7], [123.55555555, 123, 7.8]], 444, true))
    expect(multi_point.srid).to eql(444)
    expect(multi_point[0].srid).to eql(444)
  end

  it 'test_multi_line_string' do
    @ewkt_parser.parse('SRID=256;MULTILINESTRING((1.5 45.2,-54.12312 -0.012),(1.5 45.2,-54.12312 -0.012,45.123 123.3))')
    multi_line_string = @factory.geometry
    expect(multi_line_string).to be_instance_of GeoRuby::SimpleFeatures::MultiLineString
    expect(multi_line_string).to eq(GeoRuby::SimpleFeatures::MultiLineString.from_line_strings([GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5, 45.2], [-54.12312, -0.012]], 256), GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5, 45.2], [-54.12312, -0.012], [45.123, 123.3]], 256)], 256))
    expect(multi_line_string.srid).to eql(256)
    expect(multi_line_string[0].srid).to eql(256)

    @ewkt_parser.parse('SRID=256;MULTILINESTRING((1.5 45.2 1.3 1.2,-54.12312 -0.012 1.2 4.5),(1.5 45.2 5.1 -4.5,-54.12312 -0.012 -6.8 3.4,45.123 123.3 4.5 -5.3))')
    multi_line_string = @factory.geometry
    expect(multi_line_string).to be_instance_of GeoRuby::SimpleFeatures::MultiLineString
    expect(multi_line_string).to eq(GeoRuby::SimpleFeatures::MultiLineString.from_line_strings([GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5, 45.2, 1.3, 1.2], [-54.12312, -0.012, 1.2, 4.5]], 256, true, true), GeoRuby::SimpleFeatures::LineString.from_coordinates([[1.5, 45.2, 5.1, -4.5], [-54.12312, -0.012, -6.8, 3.4], [45.123, 123.3, 4.5, -5.3]], 256, true, true)], 256, true, true))
    expect(multi_line_string.srid).to eql(256)
    expect(multi_line_string[0].srid).to eql(256)
  end

  it 'test_multi_polygon' do
    ewkt = 'SRID=256;MULTIPOLYGON(((12.4 -45.3,45.4 41.6,4.456 1.0698,12.4 -45.3),(2.4 5.3,5.4 1.4263,14.46 1.06,2.4 5.3)),((0.0 0.0,4.0 0.0,4.0 4.0,0.0 4.0,0.0 0.0),(1.0 1.0,3.0 1.0,3.0 3.0,1.0 3.0,1.0 1.0)))'
    @ewkt_parser.parse(ewkt)
    multi_polygon = @factory.geometry
    expect(multi_polygon).to be_instance_of GeoRuby::SimpleFeatures::MultiPolygon
    expect(multi_polygon).to eq(GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4, -45.3], [45.4, 41.6], [4.456, 1.0698], [12.4, -45.3]], [[2.4, 5.3], [5.4, 1.4263], [14.46, 1.06], [2.4, 5.3]]], 256), GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0], [4, 0], [4, 4], [0, 4], [0, 0]], [[1, 1], [3, 1], [3, 3], [1, 3], [1, 1]]], 256)], 256))
    expect(multi_polygon.srid).to eql(256)
    expect(multi_polygon[0].srid).to eql(256)
    expect(ewkt).to eq(multi_polygon.as_ewkt)

    ewkt = 'MULTIPOLYGON(((12.4 -45.3 2,45.4 41.6 3,4.456 1.0698 4,12.4 -45.3 2),(2.4 5.3 1,5.4 1.4263 3.44,14.46 1.06 4.5,2.4 5.3 1)),((0 0 5.6,4 0 5.4,4 4 1,0 4 23,0 0 5.6),(1 1 2.3,3 1 4,3 3 5,1 3 6,1 1 2.3)))'
    @ewkt_parser.parse(ewkt)
    multi_polygon = @factory.geometry
    expect(multi_polygon).to be_instance_of GeoRuby::SimpleFeatures::MultiPolygon
    expect(multi_polygon).to eq(GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4, -45.3, 2], [45.4, 41.6, 3], [4.456, 1.0698, 4], [12.4, -45.3, 2]], [[2.4, 5.3, 1], [5.4, 1.4263, 3.44], [14.46, 1.06, 4.5], [2.4, 5.3, 1]]], 4326, true), GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0, 5.6], [4, 0, 5.4], [4, 4, 1], [0, 4, 23], [0, 0, 5.6]], [[1, 1, 2.3], [3, 1, 4], [3, 3, 5], [1, 3, 6], [1, 1, 2.3]]], 4326, true)], 4326, true))
    expect(multi_polygon.srid).to eql(4326)
    expect(multi_polygon[0].srid).to eql(4326)
  end

  it 'test_geometry_collection' do
    @ewkt_parser.parse('SRID=256;GEOMETRYCOLLECTION(POINT(4.67 45.4),LINESTRING(5.7 12.45,67.55 54),POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1,3 1,3 3,1 3,1 1)))')
    geometry_collection = @factory.geometry
    expect(geometry_collection).to be_instance_of GeoRuby::SimpleFeatures::GeometryCollection
    expect(geometry_collection).to eq(GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([GeoRuby::SimpleFeatures::Point.from_x_y(4.67, 45.4, 256), GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7, 12.45], [67.55, 54]], 256), GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[0, 0], [4, 0], [4, 4], [0, 4], [0, 0]], [[1, 1], [3, 1], [3, 3], [1, 3], [1, 1]]], 256)], 256))
    expect(geometry_collection[0].srid).to eql(256)

    @ewkt_parser.parse('SRID=256;GEOMETRYCOLLECTIONM(POINTM(4.67 45.4 45.6),LINESTRINGM(5.7 12.45 5.6,67.55 54 6.7))')
    geometry_collection = @factory.geometry
    expect(geometry_collection).to be_instance_of GeoRuby::SimpleFeatures::GeometryCollection
    expect(geometry_collection).to eq(GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([GeoRuby::SimpleFeatures::Point.from_x_y_m(4.67, 45.4, 45.6, 256), GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7, 12.45, 5.6], [67.55, 54, 6.7]], 256, false, true)], 256, false, true))
    expect(geometry_collection[0].srid).to eql(256)
  end

end
