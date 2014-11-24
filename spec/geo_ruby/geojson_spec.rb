require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

DATA_DIR = File.dirname(__FILE__) + '/../data/geojson/'

# All geojson test examples are from the GeoJSON spec unless otherwise
# specified
#
# TODO Refactor comon test approaches into methods
# TODO Add use of contexts?
describe GeoRuby::GeoJSONParser do

  it 'should create a specified GeoRuby::SimpleFeatures::Point' do
    point_json = %( { "type": "Point", "coordinates": [100.0, 0.0] } )
    point = GeoRuby::SimpleFeatures::Geometry.from_geojson(point_json)
    expect(point.class).to eql(GeoRuby::SimpleFeatures::Point)
    point_hash = JSON.parse(point_json)
    expect(point.to_coordinates).to eql(point_hash['coordinates'])
  end

  it 'should create a specified GeoRuby::SimpleFeatures::LineString' do
    ls_json = %( { "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]} )
    line_string = GeoRuby::SimpleFeatures::Geometry.from_geojson(ls_json)
    expect(line_string.class).to eql(GeoRuby::SimpleFeatures::LineString)
    ls_hash = JSON.parse(ls_json)
    expect(line_string.to_coordinates).to eql(ls_hash['coordinates'])
  end

  it 'should create a specified GeoRuby::SimpleFeatures::Polygon' do
    poly_json = <<-EOJ
      { "type": "Polygon",
        "coordinates": [
          [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
          [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
          ]
      }
    EOJ
    polygon = GeoRuby::SimpleFeatures::Geometry.from_geojson(poly_json)
    expect(polygon.class).to eql(GeoRuby::SimpleFeatures::Polygon)
    expect(polygon.rings.size).to eql(2)
    poly_hash = JSON.parse(poly_json)
    expect(polygon.to_coordinates).to eql(poly_hash['coordinates'])
  end

  it 'should create a specified GeoRuby::SimpleFeatures::MultiPoint' do
    mp_json = <<-EOJ
      { "type": "MultiPoint",
        "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
        }
    EOJ
    multi_point = GeoRuby::SimpleFeatures::Geometry.from_geojson(mp_json)
    expect(multi_point.class).to eql(GeoRuby::SimpleFeatures::MultiPoint)
    mp_hash = JSON.parse(mp_json)
    expect(multi_point.to_coordinates).to eql(mp_hash['coordinates'])
  end

  it 'should create a specified GeoRuby::SimpleFeatures::MultiLineString' do
    mls_json = <<-EOJ
      { "type": "MultiLineString",
        "coordinates": [
            [ [100.0, 0.0], [101.0, 1.0] ],
            [ [102.0, 2.0], [103.0, 3.0] ]
          ]
      }
    EOJ
    multi_ls = GeoRuby::SimpleFeatures::Geometry.from_geojson(mls_json)
    expect(multi_ls.class).to eql(GeoRuby::SimpleFeatures::MultiLineString)
    mls_hash = JSON.parse(mls_json)
    expect(multi_ls.to_coordinates).to eql(mls_hash['coordinates'])
  end

  it 'should create a specifiead GeoRuby::SimpleFeatures::MultiPolygon' do
    mpoly_json = <<-EOJ
      { "type": "MultiPolygon",
        "coordinates": [
          [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
          [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
           [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
          ]
        }
    EOJ
    mpoly = GeoRuby::SimpleFeatures::Geometry.from_geojson(mpoly_json)
    expect(mpoly.class).to eql(GeoRuby::SimpleFeatures::MultiPolygon)
    mpoly_hash = JSON.parse(mpoly_json)
    expect(mpoly.to_coordinates).to eql(mpoly_hash['coordinates'])
  end

  it 'should create a specified GeoRuby::SimpleFeatures::GeometryCollection' do
    gcol_json = <<-EOJ
      { "type": "GeometryCollection",
        "geometries": [
          { "type": "Point",
            "coordinates": [100.0, 0.0]
            },
          { "type": "LineString",
            "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
            }
        ]
      }
    EOJ
    gcol = GeoRuby::SimpleFeatures::Geometry.from_geojson(gcol_json)
    expect(gcol.class).to eql(GeoRuby::SimpleFeatures::GeometryCollection)
    gcol_hash = JSON.parse(gcol_json)
    gcol.geometries.each_with_index do |g, i|
      gh = gcol_hash['geometries'][i]
      expect(g.class).to eql(GeoRuby::SimpleFeatures.const_get(gh['type']))
      expect(g.to_coordinates).to eql(gh['coordinates'])
    end
  end

  # Feature GeoJSON test example from wikipedia entry
  it 'should create a specified Feature' do
    feature_json = <<-EOJ
      {
        "type":"Feature",
        "id":"OpenLayers.Feature.Vector_314",
        "properties":{"prop0": "value0"},
        "geometry":{
          "type":"Point",
          "coordinates":[97.03125, 39.7265625]
        }
      }
    EOJ
    f = GeoRuby::SimpleFeatures::Geometry.from_geojson(feature_json)
    expect(f.class).to eql(GeoRuby::GeoJSONFeature)
    feature_hash = JSON.parse(feature_json)
    expect(f.id).to eql(feature_hash['id'])
    expect(f.properties).to eql(feature_hash['properties'])
    expect(f.geometry.class).to eql(GeoRuby::SimpleFeatures.const_get(feature_hash['geometry']['type']))
    expect(f.geometry.to_coordinates).to eql(feature_hash['geometry']['coordinates'])
  end

  it 'should create a specified FeatureCollection' do
    fcol_json = File.read(DATA_DIR + 'feature_collection.json')
    fcol = GeoRuby::SimpleFeatures::Geometry.from_geojson(fcol_json)
    expect(fcol.class).to eql(GeoRuby::GeoJSONFeatureCollection)
    fcol_hash = JSON.parse(fcol_json)
    fcol.features.each_with_index do |f, i|
      fgh = fcol_hash['features'][i]['geometry']
      fg = f.geometry
      expect(f.properties).to eql(fcol_hash['features'][i]['properties'])
      expect(fg.class).to eql(GeoRuby::SimpleFeatures.const_get(fgh['type']))
      expect(fg.to_coordinates).to eql(fgh['coordinates'])
    end
  end

end
